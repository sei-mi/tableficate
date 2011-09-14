module Tablificate
  class Table
    attr_reader :columns, :rows

    def initialize(template, data)
      @template = template
      @columns  = []
      @rows     = data
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
