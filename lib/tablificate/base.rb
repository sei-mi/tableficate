module Tablificate
  class Base
    def self.find_by_params(params)
      v = @model

      # sorting
      if params[:sort].present?
        v = v.order(@sort[params[:sort].to_sym] || "#{params[:sort]} ASC")
        if params[:dir] == 'D'
          v = v.reverse_order
        end
      end

      # pagination
      if defined? ::Kaminari
        v = v.page(params[:page] || 1)
        v = v.per(params[:per]) if params[:per].present?
      else
        v.all
      end

      v
    end

    def self.scope(model)
      @model = model.to_s.camelize.constantize
    end

    def self.column(label, opts = {})
      @sort ||= {}
      @sort[label] = opts[:sort] if opts[:sort].present?
    end
  end
end
