module Tableficate
  module Filter
    class InputFieldStart < InputField
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

    class InputFieldStop < InputField
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

    class InputFieldRange < Base
      attr_reader :start, :stop

      def initialize(table, name, options = {})
        start_options = options.delete(:start) || {}
        stop_options  = options.delete(:stop)  || {}

        super(table, name, options)

        start_options.reverse_merge!(@options)
        start_options.reverse_merge!(label: self.label)
        stop_options.reverse_merge!(@options)
        stop_options.reverse_merge!(label: self.label)

        @start = InputFieldStart.new(table, name, start_options)
        @stop  = InputFieldStop.new(table, name, stop_options)

        # look for a template for this class and if none exists step through the ancestors until we find one
        current_class = self.class
        while not table.template.lookup_context.exists?(Tableficate::Utils::template_path(@template, table.options[:theme]), [], true)
          current_class = current_class.superclass

          raise MissingTemplate if current_class == Base

          @template = 'filters/' + current_class.name.demodulize.underscore
        end
      end
    end
  end
end
