module Tablificate
  class Base
    def self.find_by_params(params)
      scope = @scope

      # filtering
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

              scope = scope.where(["#{@filter[name][:field]} LIKE ?", value])
            elsif value.is_a?(Array)
              if @filter[name][:match] == 'contains'
                scope = scope.where(["#{name.to_s.gsub(/\W/, '')} REGEXP ?", value.join('|')])
              else
                scope = scope.where(name => value)
              end
            elsif value.is_a?(Hash)
              scope = scope.where(["#{name.to_s.gsub(/\W/, '')} BETWEEN :start AND :stop", value])
            end
          elsif value.is_a?(Hash)
            scope = scope.where(["#{name.to_s.gsub(/\W/, '')} BETWEEN :start AND :stop", value])
          else
            scope = scope.where(name => value)
          end
        end
      end

      # sorting
      column = params[:sort] || (@default_sort && @default_sort[0])
      dir    = params[:dir]  || (@default_sort && @default_sort[1])
      if column.present?
        scope = scope.order((@sort && @sort[column.to_sym]) || "#{column.to_s} ASC")
        if dir == 'desc'
          scope = scope.reverse_order
        end
      end

      # return an arel object with our data attached
      scope = scope.tablificate_ext
      sorting = {column: nil, dir: nil}
      if column.present?
        sorting[:column] = column.to_sym
        sorting[:dir]    = (dir.present? and ['asc', 'desc'].include?(dir)) ? dir : 'asc'
      end
      scope.tablificate_add_data(:current_sort, sorting)
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
  end
end
