module Tableficate
  module Utils
    def self.template_path(template, partial, theme = '')
      file = File.join(['tableficate', theme, partial].delete_if(&:blank?))

      file = File.join(['tableficate', partial]) if not theme.blank? and not template.lookup_context.exists?(file, [], true)

      file
    end

    def self.find_column_type(scope, name)
      name = name.to_s
      column = scope.columns.detect{|column| column.name == name} ||
      (
        (scope.respond_to?(:joins_values) ? scope.joins_values : []) +
        (scope.respond_to?(:includes_values) ? scope.includes_values : [])
      ).uniq.map{|join|
        # convert string joins to table names
        if join.is_a?(String)
          join.scan(/(?:(?:,|\bjoin\s*)\s*(\w+))/i)
        else
          join
        end
      }.flatten.map{|table_name|
        ActiveRecord::Base::connection_pool.columns[table_name.to_s.tableize]
      }.flatten.detect{|column|
        column.name == name
      }
      column.try(:type)
    end
  end
end
