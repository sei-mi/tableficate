module Tableficate
  module Finder
    def tableficate(params)
      scope = @scope || self
      raise Tableficate::MissingScope unless scope.new.kind_of?(ActiveRecord::Base)

      # filtering
      if params and params[:filter]
        params[:filter].each do |name, value|
          next if value.blank? or (value.is_a?(Hash) and value.all?{|key, value| value.blank?})

          # cleanup filter params
          name = name.to_sym
          if value.is_a?(Array)
            value.map!{|v| prepare_value(v)}
          elsif value.is_a?(Hash)
            value.each do |k, v|
              value[k] = prepare_value(v)
            end
          else
            value = prepare_value(value)
          end

          # convert dates, datetimes, and timestamps to Ruby objects and account for date filtering on datetime type columns
          case Tableficate::Utils::find_column_type(scope, name)
          when :date
            value = value.to_date
          when :datetime, :timestamp
            if value.is_a?(Hash)
              # if it looks like it's only dates
              if value[:start].gsub(/\D/, '').length <= 8 and value[:stop].gsub(/\D/, '').length <= 8
                value = {start: Time.zone.parse(value[:start]), stop: Time.zone.parse(value[:stop]).advance(hours: 23, minutes: 59, seconds: 59)}
              else
                value[:start] = Time.zone.parse(value[:start])
                value[:stop]  = Time.zone.parse(value[:stop])
              end
            elsif value.is_a?(String)
              # if it looks like it's only a date
              if value.gsub(/\D/, '').length <= 8
                value = Time.zone.parse(value)
                value = {start: value, stop: value.advance(hours: 23, minutes: 59, seconds: 59)}
              else
                value = Time.zone.parse(value)
              end
            end
          end

          # attach the filter
          if @filter and @filter[name]
            if @filter[name].is_a?(Proc)
              scope = @filter[name].call(value, scope)
            elsif value.is_a?(Array)
              full_column_name = get_full_column_name(@filter[name][:field])

              if @filter[name][:match] == 'contains'
                scope = scope.where([
                  Array.new(value.size, "#{full_column_name} LIKE ?").join(' OR '),
                  *value.map{|v| "%#{v}%"}
                ])
              else
                scope = scope.where(["#{full_column_name} IN(?)", value])
              end
            elsif value.is_a?(Hash)
              scope = scope.where(["#{get_full_column_name(@filter[name][:field])} BETWEEN :start AND :stop", value])
            else
              value = "%#{value}%" if @filter[name][:match] == 'contains'

              scope = scope.where(["#{get_full_column_name(@filter[name][:field])} LIKE ?", value])
            end
          elsif value.is_a?(Array)
            scope = scope.where(["#{get_full_column_name(name.to_s.gsub(/\W/, ''))} IN(?)", value])
          elsif value.is_a?(Hash)
            scope = scope.where(["#{get_full_column_name(name.to_s.gsub(/\W/, ''))} BETWEEN :start AND :stop", value])
          else
            scope = scope.where(["#{get_full_column_name(name.to_s.gsub(/\W/, ''))} LIKE ?", value])
          end
        end
      end

      # sorting
      column = params.try(:[], :sort).try(:gsub, /\W/, '') || @default_sort.try(:[], 0)
      dir = (params.try(:[], :dir) || @default_sort.try(:[], 1) || 'asc').downcase
      if column.present?
        scope = scope.order(@sort.try(:[], column.to_sym) || "#{get_full_column_name(column.to_s)} ASC")
        scope = scope.reverse_order if dir == 'desc'
      end

      # return an arel object with our data attached
      scope = scope.tableficate_ext
      sorting = {column: nil, dir: nil}
      if column.present?
        sorting[:column] = column.to_sym
        sorting[:dir]    = ['asc', 'desc'].include?(dir) ? dir : 'asc'
      end
      scope.tableficate_data = {}
      scope.tableficate_data[:current_sort] = sorting
      filters_with_field = @filter ? @filter.select{|name, options| not options.is_a?(Proc) and options and options.has_key?(:field)} : {}
      scope.tableficate_data[:field_map] = Hash[filters_with_field.map{|name, options| [name, options[:field]]}]
      scope
    end

    def get_full_column_name(name)
      name = name.to_s
      scope = @scope || self

      if scope.column_names.include?(name)
        "#{scope.table_name}.#{name}"
      else
        name
      end
    end
    private :get_full_column_name

    def prepare_value(value)
      value.strip! if value.respond_to?(:strip!)
      value = true if value == 'true'
      value = false if value == 'false'
      value
    end
    private :prepare_value
  end
end
