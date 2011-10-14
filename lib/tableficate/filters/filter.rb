module Tableficate
  class Filter
    attr_reader :name, :label, :options, :template, :table, :field_name

    def initialize(table, name, options = {})
      @table   = table
      @name    = name
      @options = options

      @template   = self.class.name.demodulize.underscore
      @label      = @options[:label] || table.columns.detect{|column| column.name == @name}.try(:header) || name.to_s.titleize
      @field_name = "#{table.as}[filter][#{@name}]"
    end

    def field_value(params)
      params[:filter][@name] rescue ''
    end
  end
end
