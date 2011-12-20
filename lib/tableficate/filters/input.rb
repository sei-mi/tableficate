module Tableficate
  module Filter
    class Input < Base
      def initialize(table, name, options = {})
        super(table, name, options)

        new_template = "filters/input_#{@attrs[:type]}"
        @template = new_template if table.template.lookup_context.exists?(Tableficate::Utils::template_path(new_template, table.theme), [], true)
      end
    end
  end
end
