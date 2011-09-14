module Tablificate
  class Base
    def self.find_by_params(params)
      v = @scope

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
      elsif defined? ::WillPaginate
        paginate_opts = {page: params[:page] || 1}
        paginate_opts[:per_page] = params[:per] if params[:per].present?
        v = v.paginate(paginate_opts)
      else
        v.all
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
