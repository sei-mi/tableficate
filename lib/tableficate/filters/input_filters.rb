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
  end

  class InputStopFilter < InputFilter
    def initialize(table, name, options = {})
      super(table, name, options)

      @field_name += '[stop]'
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

      @start = InputStartFilter.new(table, "#{name}_start", start_options)
      @stop  = InputStopFilter.new(table, "#{name}_stop",  stop_options)
    end
  end
end
