module Tableficate
  module Filter
    class TextFieldRange < InputFieldRange
      def initialize(table, name, options)
        super(table, name, options)

        # look for a template for this class and if none exists step through the ancestors until we find one
        current_class = self.class
        while not table.template.lookup_context.exists?(Tableficate::Utils::template_path(@template, table.options[:theme]), [], true)
          current_class = current_class.superclass

          raise MissingTemplate if current_class == Base

          @template = 'filters/' + current_class.name.demodulize.underscore
        end
      end
    end
  end
end
