module Tableficate
  class Base
    def self.find_by_params(params)
      scope = @scope

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
                  scope = scope.where(["#{full_column_name} REGEXP ?", value.join('|')])
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

        # sorting
        column = params[:sort].try(:gsub, /\W/, '') || @default_sort.try(:[], 0)
        dir    = params[:dir]                       || @default_sort.try(:[], 1)
        if column.present?
          scope = scope.order(@sort.try(:[], column.to_sym) || "#{get_full_column_name(column.to_s)} ASC")
          if dir == 'desc'
            scope = scope.reverse_order
          end
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

    def self.scope(model = nil, &block)
      if block_given?
        @scope = block.call
      else
        @scope = model.to_s.camelize.constantize
      end
    end

    def self.default_sort(name, dir = 'asc')
      @default_sort = [name, dir]
    end

    def self.column(name, options = {})
      @sort ||= {}

      @sort[name] = options[:sort] if options[:sort].present?
    end

    def self.filter(name, options = {}, &block)
      @filter ||= {}

      if block_given?
        @filter[name] = block
      else
        options.reverse_merge!(
          field: name
        )

        @filter[name] = options
      end
    end

    def self.get_full_column_name(name)
      name = name.to_s

      if @scope.column_names.include?(name)
        "#{@scope.table_name}.#{name}"
      else
        name
      end
    end
    private_class_method :get_full_column_name
  end
end
