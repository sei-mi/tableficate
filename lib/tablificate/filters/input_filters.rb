module Tablificate
  class InputFilter < Filter
    def initialize(table, name, attributes = {})
      super(table, name, attributes)

      @attributes.reverse_merge!(
        type: 'text'
      )

      if not Dir.glob('app/views/' + Tablificate::Utils::template_path("_#{@attributes[:type]}_#{@template}.html.*", table.options[:theme])).empty?
        @template = "#{@attributes[:type]}_#{@template}"
      end
    end
  end

  class InputRangeFilter < Filter
    attr_reader :start, :stop

    def initialize(table, name, options = {})
      start_attributes = options.delete(:start) || {}
      stop_attributes  = options.delete(:stop)  || {}

      super(table, name, options)

      start_attributes.reverse_merge!(@attributes)
      start_attributes.reverse_merge!(label: self.label)
      stop_attributes.reverse_merge!(@attributes)
      stop_attributes.reverse_merge!(label: self.label)

      @start = InputFilter.new(table, "#{name}_start", start_attributes)
      @stop  = InputFilter.new(table, "#{name}_stop",  stop_attributes)
    end
  end
end
