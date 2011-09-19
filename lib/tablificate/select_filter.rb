module Tablificate
  class SelectFilter < Filter
    attr_reader :options

    def initialize(template, table, name, options, attributes = {})
      super(template, table, name, attributes)

      @options = options
    end

    def render(options = {})
      options.reverse_merge!(
        partial: 'tablificate/select_filter',
        locals:  {filter: self}
      )

      super(options)
    end
  end
end
