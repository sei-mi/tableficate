module Tableficate
  module Filter
    class Radio < Base
      attr_reader :collection

      def initialize(table, name, options = {})
        @collection = options.delete(:collection) || []

        super(table, name, options)
      end
    end
  end
end
