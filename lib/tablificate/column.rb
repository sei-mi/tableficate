module Tablificate
  class Column
    attr_reader :label, :header

    def initialize(label, opts = {})
      @label    = label
      @header   = opts[:header] || label.to_s.titleize
      @format   = opts[:format]
      @sortable = opts[:sortable] == false ? false : true
    end

    def value(row)
      if @format
        @format.call(row)
      else
        row.send(@label)
      end
    end

    def sortable?
      @sortable
    end
  end
end
