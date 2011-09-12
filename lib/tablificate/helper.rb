module Tablificate
  module Helper
    def table_for(data, &block)
      t = Tablificate::Table.new(self, data)
      yield(t)
      t.to_s
    end
  end
end
