module Tablificate
  class Table
    def initialize(template, data)
      @template = template
      @columns  = []
      @data     = data
    end

    def column(label, opts = {})
      @columns.push(Column.new(label, opts))
    end

    def to_s
      @template.render partial: 'tablificate/table', locals: {columns: @columns, rows: @data}
    end
  end
end
