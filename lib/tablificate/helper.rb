module Tablificate
  module Helper
    def table_for(data, &block)
      t = Tablificate::Table.new(self, data, data.tablificate_get_data)
      yield(t)
      t.to_s
    end
  end
end
