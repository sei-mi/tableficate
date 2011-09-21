module Tablificate
  class InputFilter < Filter
    def initialize(template, table, name, attributes = {})
      super(template, table, name, attributes)

      @attributes.reverse_merge!(
        type: 'text'
      )
    end

    def render(options = {})
      options.reverse_merge!(
        partial: 'tablificate/input_filter',
        locals:  {filter: self}
      )

      super(options)
    end
  end

  class InputRangeFilter < Filter
    attr_reader :start, :stop

    def initialize(template, table, name, options = {})
      start_attributes = options.delete(:start) || {}
      stop_attributes  = options.delete(:stop)  || {}

      super(template, table, name, options)

      start_attributes.reverse_merge!(@attributes)
      start_attributes.reverse_merge!(label: self.label)
      stop_attributes.reverse_merge!(@attributes)
      stop_attributes.reverse_merge!(label: self.label)

      @start = InputFilter.new(template, table, "#{name}_start", start_attributes)
      @stop  = InputFilter.new(template, table, "#{name}_stop",  stop_attributes)
    end

    def render(options = {})
      options.reverse_merge!(
        partial: 'tablificate/input_range_filter',
        locals:  {filter: self}
      )

      super(options)
    end
  end
end
