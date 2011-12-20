module Tableficate
  module Helper
    def table_for(rows, options = {})
      t = Tableficate::Table.new(self, rows, options, rows.tableficate_get_data)
      yield(t)
      t.template.render(partial: Tableficate::Utils::template_path('table_for', t.theme), locals:  {table: t})
    end

    def tableficate_table_tag(table)
      render partial: Tableficate::Utils::template_path('table', table.theme), locals: {table: table}
    end

    def tableficate_header_tag(column)
      render partial: Tableficate::Utils::template_path('header', column.table.theme), locals: {column: column}
    end

    def tableficate_data_tag(row, column)
      render partial: Tableficate::Utils::template_path('data', column.table.theme), locals: {row: row, column: column}
    end

    def tableficate_row_tag(row, columns)
      render partial: Tableficate::Utils::template_path('row', columns.first.table.theme), locals: {row: row, columns: columns}
    end

    def tableficate_filter_tag(filter)
      render partial: Tableficate::Utils::template_path(filter.template, filter.table.theme), locals: {filter: filter}
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

    def tableficate_radio_tags(filter, &block)
      field_value = filter.field_value(params[filter.table.as])

      collection = Tableficate::Filter::Collection.new(filter.collection, selected: filter.field_value(params[filter.table.as]))

      html = []
      if block_given?
        html = collection.map {|choice| capture(choice, &block)}
      else
        collection.each do |choice|
          html.push(
            radio_button_tag(filter.field_name, choice.value, choice.checked?, choice.attrs),
            label_tag("#{filter.field_name}[#{choice.value}]", choice.name),
            '<br/>'
          )
        end
      end

      html.join("\n").html_safe
    end

    def tableficate_check_box_tags(filter, &block)
      field_value = filter.field_value(params[filter.table.as])

      collection = Tableficate::Filter::Collection.new(filter.collection, selected: filter.field_value(params[filter.table.as]))

      html = []
      if block_given?
        html = collection.map {|choice| capture(choice, &block)}
      else
        collection.each do |choice|
          html.push(
            check_box_tag(
              "#{filter.field_name}[#{choice.value}]", choice.value, choice.checked?, choice.attrs.reverse_merge(name: "#{filter.field_name}[]")
            ),
            label_tag("#{filter.field_name}[#{choice.value}]", choice.name),
            '<br/>'
          )
        end
      end

      html.join("\n").html_safe
    end
  end
end
