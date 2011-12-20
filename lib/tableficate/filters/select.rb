module Tableficate
  module Filter
    class Select < Base
      attr_reader :collection

      def initialize(table, name, options = {})
        @collection = options.delete(:collection) || []

        super(table, name, options)
      end
    end
  end
end
