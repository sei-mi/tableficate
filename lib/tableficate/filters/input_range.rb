module Tableficate
  module Filter
    class InputStart < Input
      def initialize(table, name, options = {})
        super(table, name, options)

        @field_name += '[start]'
      end

      def name
        "#{@name}_start".to_sym
      end

      def field_value(params)
        params[:filter][@name][:start] rescue ''
      end
    end

    class InputStop < Input
      def initialize(table, name, options = {})
        super(table, name, options)

        @field_name += '[stop]'
      end

      def name
        "#{@name}_stop".to_sym
      end

      def field_value(params)
        params[:filter][@name][:stop] rescue ''
      end
    end

    class InputRange < Base
      attr_reader :start, :stop

      def initialize(table, name, options = {})
        start_options = options.delete(:start) || {}
        stop_options  = options.delete(:stop)  || {}

        super(table, name, options)

        start_options.reverse_merge!(@attrs)
        start_options.reverse_merge!(label: self.label, label_options: self.label_options)
        stop_options.reverse_merge!(@attrs)
        stop_options.reverse_merge!(label: self.label, label_options: self.label_options)

        @start = InputStart.new(table, name, start_options)
        @stop  = InputStop.new(table, name, stop_options)

        new_partial = "filters/input_range_#{@attrs[:type]}"
        @template = new_partial if table.template.lookup_context.exists?(Tableficate::Utils::template_path(table.template, new_partial, table.theme), [], true)
      end
    end
  end
end
