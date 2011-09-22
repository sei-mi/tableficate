module Tablificate
  class Column
    attr_reader :name, :header, :table

    def initialize(table, name, options = {})
      @table   = table
      @name    = name
      @options = options

      @header = @options.delete(:header) || name.to_s.titleize
    end

    def value(row)
      if @options[:format]
        @options[:format].call(row)
      else
        row.send(@name)
      end
    end

    def show_sort?
      !!@options[:show_sort]
    end

    def is_sorted?(dir = nil)
      is_sorted = @table.current_sort[:column] == self.name
      
      if is_sorted and dir
        is_sorted = @table.current_sort[:dir] == dir
      end

      is_sorted
    end
  end
end
