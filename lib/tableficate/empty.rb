module Tableficate
  class Empty
    def initialize(table, *args, &block)
      @table = table

      if block_given?
        @attrs   = args.first || {}
        @content = block
      else
        @content = args[0]
        @attrs   = args[1] || {}
      end
    end

    def value
      if @content.is_a?(String)
        @content
      else
        output = @content.call
        if output.is_a?(ActionView::OutputBuffer)
          ''
        else
          output = output.html_safe if output.respond_to? :html_safe
          output
        end
      end
    end

    def attrs
      @attrs[:colspan] = @table.columns.length
      @attrs
    end
  end
end
