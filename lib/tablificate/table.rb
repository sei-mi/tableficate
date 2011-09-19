module Tablificate
  class Table
    attr_reader :columns, :rows, :current_sort, :filters

    def initialize(template, rows, options, data)
      @template = template
      @rows     = rows
      @columns  = []
      @filters  = []

      @options = {
        sortable:   false,
        filterable: false
      }.merge(options)

      @current_sort = data[:current_sort]
    end

    def column(name, options = {}, &block)
      options[:format] = block if block_given?
      options.reverse_merge!(
        sortable:   @options[:sortable],
        filterable: @options[:filterable]
      )

      @columns.push(Column.new(@template, self, name, options))
    end

    def sortable?
      self.columns.detect{|column| column.sortable?}
    end

    def filterable?
      self.columns.detect{|column| column.filterable?}
    end

    def input_filter(name, options = {})
      @filters.push(InputFilter.new(@template, self, name, options))
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
