module Tableficate
  class InputFilter < Filter
    def initialize(table, name, options = {})
      super(table, name, options)

      type = @options[:field_options][:type] rescue 'text'

      if not Dir.glob('app/views/' + Tableficate::Utils::template_path("_#{type}_#{@template}.html.*", table.options[:theme])).empty?
        @template = "#{type}_#{@template}"
      end
    end
  end

  class InputStartFilter < InputFilter
    def initialize(table, name, options = {})
      super(table, name, options)

      @field_name += '[start]'
    end

    def name
      "#{@name}_start"
    end

    def field_value(params)
      params[:filter][@name][:start] rescue ''
    end
  end

  class InputStopFilter < InputFilter
    def initialize(table, name, options = {})
      super(table, name, options)

      @field_name += '[stop]'
    end

    def name
      "#{@name}_stop"
    end

    def field_value(params)
      params[:filter][@name][:stop] rescue ''
    end
  end

  class InputRangeFilter < Filter
    attr_reader :start, :stop

    def initialize(table, name, options = {})
      start_options = options.delete(:start) || {}
      stop_options  = options.delete(:stop)  || {}

      super(table, name, options)

      start_options.reverse_merge!(@options)
      start_options.reverse_merge!(label: self.label)
      stop_options.reverse_merge!(@options)
      stop_options.reverse_merge!(label: self.label)

      @start = InputStartFilter.new(table, name, start_options)
      @stop  = InputStopFilter.new(table, name,  stop_options)
    end
  end
end
