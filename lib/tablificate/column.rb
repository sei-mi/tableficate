module Tablificate
  class Column
    attr_reader :label, :header

    def initialize(label, opts = {})
      @label  = label
      @header = opts[:header] || label.to_s.titleize
    end
  end
end
