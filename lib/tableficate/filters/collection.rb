module Tableficate
  module Filter
    class Collection < Array
      def initialize(container, options = {})
        container = container.to_a if container.is_a?(Range)

        selected = Array.wrap(options[:selected]).map{|item| item.to_s}
        disabled = Array.wrap(options[:disabled]).map{|item| item.to_s}

        container.map do |element|
          text, value, choice_options = case
            when Array === element
              html_attrs = element.detect {|e| Hash === e} || {}
              element = element.reject {|e| Hash === e} 
              [element.first, element.last, html_attrs]
            when !element.is_a?(String) && element.respond_to?(:first) && element.respond_to?(:last)
              [element.first, element.last, {}]
            else
              [element, element, {}]
            end

          choice_options[:selected] = 'selected' if selected.include?(value.to_s)
          choice_options[:disabled] = 'disabled' if disabled.include?(value.to_s)

          self.push(Choice.new(text, value, choice_options))
        end
      end
    end
  end
end
