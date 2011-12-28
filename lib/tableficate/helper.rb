module Tableficate
  module Helper
    def table_for(rows, options = {})
      t = Tableficate::Table.new(self, rows, options, rows.tableficate_get_data)
      yield(t)
      t.template.render(partial: Tableficate::Utils::template_path(t.template, 'table_for', t.theme), locals:  {table: t})
    end

    def tableficate_table_tag(table)
      render partial: Tableficate::Utils::template_path(table.template, 'table', table.theme), locals: {table: table}
    end

    def tableficate_header_tag(column)
      table = column.table
      render partial: Tableficate::Utils::template_path(table.template, 'header', table.theme), locals: {column: column}
    end

    def tableficate_data_tag(row, column)
      table = column.table
      render partial: Tableficate::Utils::template_path(table.template, 'data', table.theme), locals: {row: row, column: column}
    end

    def tableficate_row_tag(row, columns)
      table = columns.first.table
      render partial: Tableficate::Utils::template_path(table.template, 'row', table.theme), locals: {row: row, columns: columns}
    end

    def tableficate_filter_form_tag(table)
      render partial: Tableficate::Utils::template_path(table.template, 'filters/form', table.theme), locals: {table: table}
    end

    def tableficate_filter_tag(filter)
      table = filter.table
      render partial: Tableficate::Utils::template_path(table.template, filter.template, table.theme), locals: {filter: filter}
    end

    def tableficate_label_tag(filter)
      label_tag(filter.field_name, filter.label, filter.label_options)
    end

    def tableficate_text_field_tag(filter)
      text_field_tag(filter.field_name, filter.field_value(params[filter.table.as]), filter.attrs)
    end

    def tableficate_select_tag(filter)
      field_value = filter.field_value(params[filter.table.as])

      collection = filter.collection

      if field_value.present? and collection.is_a?(String)
        Array.wrap(field_value).each do |fv|
          if collection.match(/<option[^>]*value\s*=/)
            collection.gsub!(/(<option[^>]*value\s*=\s*['"]?#{fv}[^>]*)/, '\1 selected="selected"')
          else
            collection.gsub!(/>#{fv}</, " selected=\"selected\">#{fv}<")
          end
        end
      elsif not collection.is_a?(String)
        collection = Tableficate::Filter::Collection.new(collection, selected: field_value).map {|choice|
          html_attributes = choice.attrs.length > 0 ? ' ' + choice.attrs.map {|k, v| %(#{k.to_s}="#{v}")}.join(' ') : ''
          selected_attribute = choice.selected? ? ' selected="selected"' : ''

          %(<option value="#{ERB::Util.html_escape(choice.value)}"#{selected_attribute}#{html_attributes}>#{ERB::Util.html_escape(choice.name)}</option>)
        }.join("\n")
      end

      collection = collection.html_safe

      select_tag(filter.field_name, collection, filter.attrs)
    end

    def tableficate_radio_tags(filter)
      tableficate_collection_of_tags(filter)
    end

    def tableficate_check_box_tags(filter)
      if filter.collection.empty?
        check_box_tag(filter.field_name, true, filter.field_value(params[filter.table.as]) == 'true', filter.attrs)
      else
        tableficate_collection_of_tags(filter)
      end
    end

    def tableficate_collection_of_tags(filter)
      table       = filter.table
      field_value = filter.field_value(params[filter.table.as])

      html = []
      Tableficate::Filter::Collection.new(filter.collection, selected: field_value).each do |choice|
        html.push(
          render(partial: Tableficate::Utils::template_path(table.template, filter.template + '_choice', table.theme), locals: {filter: filter, choice: choice})
        )
      end

      html.join("\n").html_safe
    end
    private :tableficate_collection_of_tags
  end
end
