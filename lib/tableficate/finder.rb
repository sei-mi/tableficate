module Tableficate
  module Finder
    def tableficate(params)
      scope = @scope || self
      raise Tableficate::MissingScope unless scope.new.kind_of?(ActiveRecord::Base)

      # filtering
      if params
        if params[:filter]
          params[:filter].each do |name, value|
            next if value.blank? or (value.is_a?(Hash) and value.all?{|key, value| value.blank?})

            name = name.to_sym
            value.strip! if value.is_a?(String)

            if @filter and @filter[name]
              if @filter[name].is_a?(Proc)
                scope = @filter[name].call(scope, value)
              elsif value.is_a?(String)
                value = "%#{value}%" if @filter[name][:match] == 'contains'

                scope = scope.where(["#{get_full_column_name(@filter[name][:field])} LIKE ?", value])
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
      end

      # sorting
      column = params.try(:[], :sort).try(:gsub, /\W/, '') || @default_sort.try(:[], 0)
      dir    = params.try(:[], :dir)                       || @default_sort.try(:[], 1) || 'asc'
      dir.downcase!
      if column.present?
        scope = scope.order(@sort.try(:[], column.to_sym) || "#{get_full_column_name(column.to_s)} ASC")
        if dir == 'desc'
          scope = scope.reverse_order
        end
      end

      # return an arel object with our data attached
      scope = scope.tableficate_ext
      sorting = {column: nil, dir: nil}
      if column.present?
        sorting[:column] = column.to_sym
        sorting[:dir]    = (dir.present? and ['asc', 'desc'].include?(dir)) ? dir : 'asc'
      end
      scope.tableficate_add_data(:current_sort, sorting)
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
  end
end
