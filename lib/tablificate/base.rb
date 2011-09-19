module Tablificate
  class Base
    def self.find_by_params(params)
      v = @scope

      # filtering
      if params[:filter]
        params[:filter].each do |name, value|
          value.strip!

          if @filter[name.to_sym]
            name = name.to_sym
            if @filter[name].class == Proc
              v = @filter[name].call(v, value)
            else
              value = "%#{value}%" if @filter[name][:match] == 'contains'

              v = v.where(["#{@filter[name][:field]} LIKE ?", value])
            end
          else
            v = v.where(["#{name.gsub(/\W/, '')} LIKE ?", value])
          end
        end
      end

      # sorting
      column = params[:sort] || (@default_sort && @default_sort[0])
      dir    = params[:dir]  || (@default_sort && @default_sort[1])
      if column.present?
        v = v.order(@sort[column.to_sym] || "#{column.to_s} ASC")
        if dir == 'desc'
          v = v.reverse_order
        end
      end

      # return an arel object with our data attached
      v = v.tablificate_ext
      sorting = {column: nil, dir: nil}
      if column.present?
        sorting[:column] = column.to_sym
        sorting[:dir]    = (dir.present? and ['asc', 'desc'].include?(dir)) ? dir : 'asc'
      end
      v.tablificate_add_data(:current_sort, sorting)
      v
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
