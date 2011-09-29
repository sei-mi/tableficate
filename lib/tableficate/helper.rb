module Tableficate
  module Helper
    def table_for(rows, options = {})
      t = Tableficate::Table.new(self, rows, options, rows.tableficate_get_data)
      yield(t)
      t.render
    end

    def tableficate_header_tag(column)
      render partial: Tableficate::Utils::template_path('column_header', column.table.options[:theme]), locals: {column: column}
    end

    def tableficate_data_tag(row, column)
      render partial: Tableficate::Utils::template_path('data', column.table.options[:theme]), locals: {row: row, column: column}
    end

    def tableficate_row_tag(row, columns)
      render partial: Tableficate::Utils::template_path('row', columns.first.table.options[:theme]), locals: {row: row, columns: columns}
    end

    def tableficate_filter_tag(filter)
      render partial: Tableficate::Utils::template_path(filter.template, filter.table.options[:theme]), locals: {filter: filter}
    end
  end
end
