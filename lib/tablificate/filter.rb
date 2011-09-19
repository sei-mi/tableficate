module Tablificate
  class Filter
    attr_reader :name, :label, :attributes

    def initialize(template, table, name, attributes = {})
      @template   = template
      @table      = table
      @name       = name
      @attributes = attributes

      @label = @attributes.delete(:label) || name.to_s.titleize
    end

    def render(options = {})
      @template.render options
    end
  end
end
