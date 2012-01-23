module Tableficate
  class Table
    attr_reader :columns, :rows, :current_sort, :filters, :attrs, :as, :template, :theme

    def initialize(template, rows, options, data)
      @template = template
      @rows     = rows

      @as         = options.delete(:as) || rows.table_name
      @theme      = options.delete(:theme) || ''
      @show_sorts = options.delete(:show_sorts) || false
      @attrs      = options

      @columns = []
      @filters = []

      @current_sort = data[:current_sort]
      @field_map    = data[:field_map] || {}
    end

    def hidden_filters
      @filters.select{|filter| filter.attrs[:type] == 'hidden'}
    end

    def visible_filters
      @filters.reject{|filter| filter.attrs[:type] == 'hidden'}
    end

    def empty(*args, &block)
      if args.empty? and not block_given?
        @empty
      else
        @empty = Empty.new(self, *args, &block)
      end
    end

    def caption(*args, &block)
      if args.empty? and not block_given?
        @caption
      else
        @caption = Caption.new(*args, &block)
      end
    end

    def column(name, options = {}, &block)
      @columns.push(Column.new(self, name, options.reverse_merge(show_sort: @show_sorts), &block))
    end

    def actions(options = {}, &block)
      @columns.push(ActionColumn.new(self, options, &block))
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
        hidden:   Filter::Input,
        select:   Filter::Select,
        radio:    Filter::Radio,
        checkbox: Filter::CheckBox
      }

      as = options.delete(:as) || find_as(name, options.has_key?(:collection))

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

      as = options.delete(:as) || find_as(name, options.has_key?(:collection))

      raise Filter::UnknownInputType if as_map[as].nil?

      options[:type] = as.to_s

      @filters.push(as_map[as].new(self, name, options))
    end

    def find_as(name, has_collection)
      field_name = (@field_map[name] || name).to_s
      as = :text

      if has_collection
        as = :select
      else 
        case Tableficate::Utils::find_column_type(@rows, field_name)
        when :integer, :float, :decimal
          as = :number
        when :date
          as = :date
        when :time
          as = :time
        when :datetime, :timestamp
          as = :datetime
        when :boolean
          as = :checkbox
        end
      end

      if as == :text
        case name
        when /email/
          as = :email
        when /url/
          as = :url
        when /phone/
          as = :tel
        end
      end

      as
    end
    private :find_as
  end
end
