module Tableficate
  class Column
    attr_reader :name, :header, :table, :header_attrs, :cell_attrs, :attrs

    def initialize(table, name, options = {}, &block)
      @table = table
      @name  = name
      @block = block

      @header       = options.delete(:header) || name.to_s.titleize
      @header_attrs = options.delete(:header_attrs) || {}

      @cell_attrs = options.delete(:cell_attrs) || {}

      @show_sort = options.delete(:show_sort) || false

      @attrs = options
    end

    def value(row)
      if @block
        output = @block.call(row)
        if output.is_a?(ActionView::OutputBuffer)
          ''
        else
          output = output.html_safe if output.respond_to? :html_safe
          output
        end
      else
        row.send(@name)
      end
    end

    def show_sort?
      @show_sort
    end

    def is_sorted?(dir = nil)
      is_sorted = @table.current_sort[:column] == self.name
      is_sorted = @table.current_sort[:dir] == dir if is_sorted and dir

      is_sorted
    end
  end
end
