module Tablificate
  class Column
    attr_reader :label, :header

    def initialize(label, options = {})
      @label   = label
      @header  = options.delete(:header) || label.to_s.titleize
      @options = options
    end

    def value(row)
      if @options[:format]
        @options[:format].call(row)
      else
        row.send(@label)
      end
    end

    def sortable?
      @options[:sortable]
    end
  end
end
