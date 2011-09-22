module Tablificate
  class SelectFilter < Filter
    attr_reader :options

    def initialize(table, name, options, attributes = {})
      super(table, name, attributes)

      @options = options
    end
  end
end
