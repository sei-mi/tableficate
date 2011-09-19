module Tablificate
  class Table
    attr_reader :columns, :rows, :current_sort, :filters

    def initialize(template, rows, options, data)
      @template = template
      @rows     = rows
      @columns  = []
      @filters  = []

      @options = {
        show_sorts: false
      }.merge(options)

      @current_sort = data[:current_sort]
    end

    def column(name, options = {}, &block)
      options[:format] = block if block_given?
      options.reverse_merge!(
        show_sort: @options[:show_sorts]
      )

      @columns.push(Column.new(@template, self, name, options))
    end

    def show_sort?
      self.columns.detect{|column| column.show_sort?}
    end

    def input_filter(name, attributes = {})
      @filters.push(InputFilter.new(@template, self, name, attributes))
    end

    def select_filter(name, options, attributes = {})
      @filters.push(SelectFilter.new(@template, self, name, options, attributes))
    end

    def render(options = {})
      options.reverse_merge!(
        partial: 'tablificate/table',
        locals:  {table: self}
      )

      @template.render options
    end
  end
end
