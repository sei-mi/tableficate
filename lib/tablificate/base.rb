module Tablificate
  class Base
    def self.find_by_params(params)
      v = @scope

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
      if model
        @scope = model.to_s.camelize.constantize
      else
        @scope = block.call
      end
    end

    def self.default_sort(label, dir = 'asc')
      @default_sort = [label, dir]
    end

    def self.column(label, options = {})
      @sort ||= {}
      @sort[label] = options[:sort] if options[:sort].present?
    end
  end
end
