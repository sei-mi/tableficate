module Tablificate
  class Column
    attr_reader :label, :header

    def initialize(template, table, label, options = {})
      @template = template
      @table    = table
      @label    = label
      @header   = options.delete(:header) || label.to_s.titleize
      @options  = options
    end

    def value(row)
      if @options[:format]
        @options[:format].call(row)
      else
        row.send(@label)
      end
    end

    def sortable?
      !!@options[:sortable]
    end

    def is_sorted?(dir = nil)
      is_sorted = @table.current_sort[:column] == self.label
      
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
