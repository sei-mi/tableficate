module Tablificate
  class Base
    def self.find_by_params(params)
      v = @scope

      # sorting
      field = params[:sort] || (@default_sort && @default_sort[0])
      dir   = params[:dir]  || (@default_sort && @default_sort[1])
      if field.present?
        v = v.order(@sort[field.to_sym] || "#{field.to_s} ASC")
        if dir == 'desc'
          v = v.reverse_order
        end
      end

      # return an arel object with our data attached
      v = v.tablificate_ext
      sorting = {field: nil, dir: nil}
      if field.present?
        sorting[:field] = field.to_sym
        sorting[:dir]   = (dir.present? and ['asc', 'desc'].include?(dir)) ? dir : 'asc'
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

    def self.column(label, opts = {})
      @sort ||= {}
      @sort[label] = opts[:sort] if opts[:sort].present?
    end
  end
end
