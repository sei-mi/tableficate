module Tableficate
  class Column
    attr_reader :name, :header, :table

    def initialize(table, name, options = {}, &block)
      @table   = table
      @name    = name
      @options = options
      @block   = block

      @header = @options.delete(:header) || name.to_s.titleize
    end

    def value(row)
      if @block
        @block.call(row).html_safe
      else
        row.send(@name)
      end
    end

    def show_sort?
      !!@options[:show_sort]
    end

    def is_sorted?(dir = nil)
      is_sorted = @table.current_sort[:column] == self.name
      is_sorted = @table.current_sort[:dir] == dir if is_sorted and dir

      is_sorted
    end
  end
end
