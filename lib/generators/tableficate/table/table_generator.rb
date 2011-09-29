module Tableficate
  class TableGenerator < Rails::Generators::NamedBase
    desc('Create a Tableficate table model.')

    source_root File.expand_path('../templates', __FILE__)

    TABLES_PATH = 'app/tables'

    argument :scope, required: false

    def create_table
      empty_directory(TABLES_PATH)

      template('table.rb', "#{TABLES_PATH}/#{file_name.underscore}.rb")
    end
  end
end
