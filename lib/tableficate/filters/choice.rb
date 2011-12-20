module Tableficate
  module Filter
    class Choice
      attr_reader :name, :value, :attrs

      def initialize(name, value, options = {})
        @name  = name
        @value = value

        @selected = !!(options.has_key?(:selected) || options.has_key?(:checked))
        options.delete(:selected)
        options.delete(:checked)

        @attrs = options
      end

      def selected?
        @selected
      end
      alias_method :checked?, :selected?
    end
  end
end
