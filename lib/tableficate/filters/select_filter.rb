module Tableficate
  class SelectFilter < Filter
    attr_reader :choices

    def initialize(table, name, choices, options = {})
      super(table, name, options)

      @choices = choices
    end
  end
end
