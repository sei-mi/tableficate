module Tableficate
  module Filter
    class Input < Base
      def initialize(table, name, options = {})
        super(table, name, options)

        new_partial = "filters/input_#{@attrs[:type]}"
        @template = new_partial if table.template.lookup_context.exists?(Tableficate::Utils::template_path(table.template, new_partial, table.theme), [], true)
      end
    end
  end
end
