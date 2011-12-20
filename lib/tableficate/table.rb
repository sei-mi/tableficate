module Tableficate
  class Table
    attr_reader :columns, :rows, :current_sort, :filters, :attrs, :as, :template, :theme

    def initialize(template, rows, options, data)
      @template   = template
      @rows       = rows

      @as         = options.delete(:as) || rows.table_name
      @theme      = options.delete(:theme) || ''
      @show_sorts = options.delete(:show_sorts) || false
      @attrs      = options

      @columns = []
      @filters = []

      @current_sort = data[:current_sort]
    end

    def column(name, options = {}, &block)
      @columns.push(Column.new(self, name, options.reverse_merge(show_sort: @show_sorts), &block))
    end

    def actions(&block)
      @columns.push(ActionColumn.new(self, &block))
    end

    def show_sort?
      self.columns.any?{|column| column.show_sort?}
    end

    def filter(name, options = {})
      as_map = {
        :'datetime-local' => Filter::Input,
        text:     Filter::Input,
        email:    Filter::Input,
        url:      Filter::Input,
        tel:      Filter::Input,
        number:   Filter::Input,
        range:    Filter::Input,
        date:     Filter::Input,
        month:    Filter::Input,
        week:     Filter::Input,
        time:     Filter::Input,
        datetime: Filter::Input,
        search:   Filter::Input,
        color:    Filter::Input,
        select:   Filter::Select,
        radio:    Filter::Radio,
        checkbox: Filter::CheckBox
      }

      as = options.delete(:as) || (options[:collection] ? :select : :text)

      raise Filter::UnknownInputType if as_map[as].nil?

      options[:type] = as.to_s

      @filters.push(as_map[as].new(self, name, options))
    end

    def filter_range(name, options = {})
      as_map = {
        :'datetime-local' => Filter::InputRange,
        text:     Filter::InputRange,
        email:    Filter::InputRange,
        url:      Filter::InputRange,
        tel:      Filter::InputRange,
        number:   Filter::InputRange,
        range:    Filter::InputRange,
        date:     Filter::InputRange,
        month:    Filter::InputRange,
        week:     Filter::InputRange,
        time:     Filter::InputRange,
        datetime: Filter::InputRange,
        search:   Filter::InputRange,
        color:    Filter::InputRange,
        select:   Filter::SelectRange
      }

      as = options.delete(:as) || (options[:collection] ? :select : :text)

      raise Filter::UnknownInputType if as_map[as].nil?

      options[:type] = as.to_s

      @filters.push(as_map[as].new(self, name, options))
    end

    def render(options = {})
      options.reverse_merge!(
        partial: Tableficate::Utils::template_path('table', @theme),
        locals:  {table: self}
      )

      @template.render(options)
    end
  end
end
