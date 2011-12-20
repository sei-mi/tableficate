module Tableficate
  module Filter
    class SelectStart < Select
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

    class SelectStop < Select
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

    class SelectRange < Base
      attr_reader :start, :stop

      def initialize(table, name, options = {})
        start_options = options.delete(:start) || {}
        stop_options  = options.delete(:stop)  || {}

        super(table, name, options)

        start_options.reverse_merge!(@attrs)
        start_options.reverse_merge!(label: self.label, label_options: self.label_options)
        stop_options.reverse_merge!(@attrs)
        stop_options.reverse_merge!(label: self.label, label_options: self.label_options)

        @start = SelectStart.new(table, name, start_options)
        @stop  = SelectStop.new(table, name, stop_options)
      end
    end
  end
end
