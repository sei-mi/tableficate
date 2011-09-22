module Tablificate
  module Helper
    def table_for(rows, options = {}, &block)
      t = Tablificate::Table.new(self, rows, options, rows.tablificate_get_data)
      yield(t)
      t.render
    end

    def tablificate_header_tag(column)
      render partial: 'tablificate/column_header', locals: {column: column}
    end

    def tablificate_data_tag(row, column)
      render partial: 'tablificate/data', locals: {row: row, column: column}
    end

    def tablificate_row_tag(row, columns)
      render partial: 'tablificate/row', locals: {row: row, columns: columns}
    end
  end
end
