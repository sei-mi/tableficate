module Tableficate
  class ActionColumn < Column
    def initialize(table, &block)
      super(table, '', {}, &block)
    end

    def show_sort?
      false
    end

    def is_sorted?(dir = nil)
      false
    end
  end
end
