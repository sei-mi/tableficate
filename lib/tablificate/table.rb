module Tablificate
  class Table
    attr_reader :columns, :rows, :current_sort

    def initialize(template, rows, data = {})
      @template     = template
      @columns      = []
      @rows         = rows
      @current_sort = data[:current_sort]
    end

    def column(label, opts = {}, &block)
      opts[:format] = block if block_given?
      @columns.push(Column.new(label, opts))
    end

    def to_s
      @template.render partial: 'tablificate/table', locals: {table: self}
    end
  end
end
