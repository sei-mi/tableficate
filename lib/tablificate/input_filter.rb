module Tablificate
  class InputFilter < Filter
    def initialize(template, table, name, options = {})
      super(template, table, name, options)

      @attributes.reverse_merge!(
        type: 'text'
      )
    end

    def render(options = {})
      options.reverse_merge!(
        partial: 'tablificate/input_filter',
        locals:  {filter: self}
      )

      super(options)
    end
  end
end
