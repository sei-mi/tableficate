module Tablificate
  class Table
    attr_reader :columns, :rows, :current_sort, :filters, :attributes, :options

    def initialize(template, rows, options, data)
      @template = template
      @rows     = rows
      @columns  = []
      @filters  = []

      @options = {
        show_sorts: false,
        theme:      ''
      }.merge(options)

      @attributes = Attributes.new().merge(@options.delete(:html) || {})

      @current_sort = data[:current_sort]
    end

    def actions(options = {}, &block)
      @columns.push(ActionColumn.new(self, options, block))
    end

    def column(name, options = {}, &block)
      options[:format] = block if block_given?
      options.reverse_merge!(
        show_sort: @options[:show_sorts]
      )

      @columns.push(Column.new(self, name, options))
    end

    def show_sort?
      self.columns.any?{|column| column.show_sort?}
    end

    def input_filter(name, attributes = {})
      @filters.push(InputFilter.new(self, name, attributes))
    end

    def input_range_filter(name, options = {})
      @filters.push(InputRangeFilter.new(self, name, options))
    end

    def select_filter(name, options, attributes = {})
      @filters.push(SelectFilter.new(self, name, options, attributes))
    end

    def render(options = {})
      options.reverse_merge!(
        partial: Tablificate::Utils::template_path('table', @options[:theme]),
        locals:  {table: self}
      )

      @template.render options
    end
  end
end
