module Tableficate
  class SelectFilter < Filter
    attr_reader :choices

    def initialize(table, name, choices, options = {})
      super(table, name, options)

      @choices = choices
    end
  end

  class SelectStartFilter < SelectFilter
    def initialize(table, name, choices, options = {})
      super(table, name, choices, options)

      @field_name += '[start]'
    end

    def name
      "#{@name}_start".to_sym
    end

    def field_value(params)
      params[:filter][@name][:start] rescue ''
    end
  end

  class SelectStopFilter < SelectFilter
    def initialize(table, name, choices, options = {})
      super(table, name, choices, options)

      @field_name += '[stop]'
    end

    def name
      "#{@name}_stop".to_sym
    end

    def field_value(params)
      params[:filter][@name][:stop] rescue ''
    end
  end

  class SelectRangeFilter < Filter
    attr_reader :start, :stop

    def initialize(table, name, choices_start, choices_stop, options = {})
      start_options = options.delete(:start) || {}
      stop_options  = options.delete(:stop)  || {}

      super(table, name, options)

      start_options.reverse_merge!(@options)
      start_options.reverse_merge!(label: self.label)
      stop_options.reverse_merge!(@options)
      stop_options.reverse_merge!(label: self.label)

      @start = SelectStartFilter.new(table, name, choices_start, start_options)
      @stop  = SelectStopFilter.new(table, name, choices_stop, stop_options)
    end
  end
end
