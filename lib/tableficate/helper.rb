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

    def tableficate_label_tag(filter)
      label_tag(filter.field_name, filter.label, filter.options[:label_options] || {})
    end

    def tableficate_text_field_tag(filter)
      text_field_tag(filter.field_name, filter.field_value(params[filter.table.as]), filter.options[:field_options] || {})
    end

    def tableficate_select_tag(filter)
      field_value = filter.field_value(params[filter.table.as])

      if field_value.present? and filter.options[:collection].is_a?(String)
        if filter.options[:collection].match(/<option[^>]*value\s*=/)
          filter.options[:collection].gsub!(/(<option[^>]*value\s*=\s*['"]?#{field_value}[^>]*)/, '\1 selected="selected"')
        else
          filter.options[:collection].gsub!(/>#{field_value}</, " selected=\"selected\">#{field_value}<")
        end
      else
        filter.options[:collection] = options_for_select(filter.options[:collection], field_value)
      end

      filter.options[:collection] = filter.options[:collection].html_safe if filter.options[:collection].respond_to?(:html_safe)

      select_tag(filter.field_name, filter.options.delete(:collection), filter.options)
    end

    def tableficate_radio_tags(filter, &block)
      field_value = filter.field_value(params[filter.table.as])

      collection = Tableficate::Filter::Collection.new(filter.options[:collection], selected: filter.field_value(params[filter.table.as]))

      html = []
      if block_given?
        html = collection.map {|choice| capture(choice, &block)}
      else
        collection.each do |choice|
          html.push(
            radio_button_tag(filter.field_name, choice.value, choice.checked?, choice.options),
            label_tag("#{filter.field_name}[#{choice.value}]", choice.name),
            '<br/>'
          )
        end
      end

      html.join("\n").html_safe
    end
  end
end
