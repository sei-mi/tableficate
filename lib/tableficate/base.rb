module Tableficate
  class Base
    extend Tableficate::Finder

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
