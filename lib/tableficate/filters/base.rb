module Tableficate
  module Filter
    class Base
      attr_reader :name, :label, :attrs, :template, :table, :field_name, :label_options

      def initialize(table, name, options = {})
        @table = table
        @name  = name

        @label         = options.delete(:label) || table.columns.detect{|column| column.name == @name}.try(:header) || name.to_s.titleize
        @label_options = options.delete(:label_options) || {}
        @attrs         = options

        @template   = 'filters/' + self.class.name.demodulize.underscore
        @field_name = "#{table.as}[filter][#{@name}]"
      end

      def field_value(params)
        params[:filter][@name] rescue ''
      end
    end
  end
end
