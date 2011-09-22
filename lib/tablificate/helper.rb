module Tablificate
  module Helper
    def table_for(rows, options = {}, &block)
      t = Tablificate::Table.new(self, rows, options, rows.tablificate_get_data)
      yield(t)
      t.render
    end

    def tablificate_header_tag(column)
      render partial: Tablificate::Utils::template_path('column_header', column.table.options[:theme]), locals: {column: column}
    end

    def tablificate_data_tag(row, column)
      render partial: Tablificate::Utils::template_path('data', column.table.options[:theme]), locals: {row: row, column: column}
    end

    def tablificate_row_tag(row, columns)
      render partial: Tablificate::Utils::template_path('row', columns.first.table.options[:theme]), locals: {row: row, columns: columns}
    end

    def tablificate_filter_tag(filter)
      render partial: Tablificate::Utils::template_path(filter.template, filter.table.options[:theme]), locals: {filter: filter}
    end
  end
end
