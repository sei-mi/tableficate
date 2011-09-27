module Tablificate
  class Filter
    attr_reader :name, :label, :attributes, :template, :table

    def initialize(table, name, attributes = {})
      @table      = table
      @name       = name
      @attributes = attributes

      @template = self.class.name.demodulize.underscore
      @label    = @attributes.delete(:label) || table.columns.detect{|column| column.name == @name}.header
    end
  end
end
