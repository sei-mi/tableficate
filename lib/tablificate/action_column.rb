module Tablificate
  class ActionColumn < Column
    def initialize(table, options = {}, block)
      super(table, '', options, &block)
    end

    def show_sort?
      false
    end

    def is_sorted?(dir = nil)
      false
    end
  end
end
