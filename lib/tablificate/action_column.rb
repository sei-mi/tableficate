module Tablificate
  class ActionColumn < Column
    def initialize(options = {}, block)
      @options = options
      @block   = block

      @name   = ''
      @header = @options.delete(:header) || @name
    end

    def value(row)
      @block.call(row).html_safe
    end

    def show_sort?
      false
    end

    def is_sorted?(dir = nil)
      false
    end
  end
end
