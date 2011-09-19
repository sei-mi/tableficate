module Tablificate
  class Column
    attr_reader :name, :header

    def initialize(template, table, name, options = {})
      @template = template
      @table    = table
      @name     = name
      @options  = options

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

      return is_sorted
    end

    def render(options = {})
      options.reverse_merge!(
        partial: 'tablificate/column_header',
        locals:  {column: self}
      )

      @template.render options
    end
  end
end
