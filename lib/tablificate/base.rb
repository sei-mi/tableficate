module Tablificate
  class Base
    def self.find_by_params(params)
      v = @scope.scoped

      # sorting
      if params[:sort].present?
        v = v.order(@sort[params[:sort].to_sym] || "#{params[:sort]} ASC")
        if params[:dir] == 'desc'
          v = v.reverse_order
        end
      end

      v
    end

    def self.scope(model = nil, &block)
      if model
        @scope = model.to_s.camelize.constantize
      else
        @scope = block.call
      end
    end

    def self.column(label, opts = {})
      @sort ||= {}
      @sort[label] = opts[:sort] if opts[:sort].present?
    end
  end
end
