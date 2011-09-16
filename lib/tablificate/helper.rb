module Tablificate
  module Helper
    def table_for(rows, options = {}, &block)
      t = Tablificate::Table.new(self, rows, options, rows.tablificate_get_data)
      yield(t)
      t.render
    end
  end
end
