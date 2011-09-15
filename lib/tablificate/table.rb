module Tablificate
  class Table
    attr_reader :columns, :rows, :current_sort

    def initialize(template, rows, options, data)
      @template = template
      @rows     = rows
      @columns  = []

      @options = {
        sortable: false
      }.merge(options)

      @current_sort = data[:current_sort]
    end

    def column(label, options = {}, &block)
      options[:format] = block if block_given?
      options[:sortable] = @options[:sortable] if options[:sortable].nil?

      @columns.push(Column.new(label, options))
    end

    def to_s
      @template.render partial: 'tablificate/table', locals: {table: self}
    end
  end
end
