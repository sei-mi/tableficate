module Tableficate
  class Table
    attr_reader :columns, :rows, :current_sort, :filters, :options, :as, :template

    def initialize(template, rows, options, data)
      @template = template
      @rows     = rows
      @columns  = []
      @filters  = []
      @as       = options[:as] || rows.table_name

      @options = {
        show_sorts: false,
        theme:      ''
      }.merge(options)

      @current_sort = data[:current_sort]
    end

    def column(name, options = {}, &block)
      options.reverse_merge!(
        show_sort: @options[:show_sorts]
      )

      @columns.push(Column.new(self, name, options, &block))
    end

    def actions(options = {}, &block)
      @columns.push(ActionColumn.new(self, options, block))
    end

    def show_sort?
      self.columns.any?{|column| column.show_sort?}
    end

    def filter(name, options = {})
      as_map = {
        text:     Filter::Input,
        select:   Filter::Select,
        radio:    Filter::Radio,
        checkbox: Filter::CheckBox
      }

      @filters.push(as_map[options.delete(:as) || (options[:collection] ? :select : :text)].new(self, name, options))
    end

    def filter_range(name, options = {})
      as_map = {
        text:   Filter::InputRange,
        select: Filter::SelectRange
      }

      @filters.push(as_map[options.delete(:as) || (options[:collection] ? :select : :text)].new(self, name, options))
    end

    def render(options = {})
      options.reverse_merge!(
        partial: Tableficate::Utils::template_path('table', @options[:theme]),
        locals:  {table: self}
      )

      @template.render options
    end
  end
end
