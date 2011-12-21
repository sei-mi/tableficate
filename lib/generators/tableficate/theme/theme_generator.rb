module Tableficate
  class ThemeGenerator < Rails::Generators::NamedBase
    desc('Create a Tableficate theme.')

    VIEW_PATH = 'app/views/tableficate'

    source_root File.expand_path("../../../../../#{VIEW_PATH}", __FILE__)

    argument :partial, required: false

    def create_theme
      empty_directory(VIEW_PATH)

      if partial
        if partial =~ /\//
          partial =~ /^(.*)\/(.*)$/
          extra_dirs   = $1
          partial_name = $2

          empty_directory("#{VIEW_PATH}/#{file_name}/#{extra_dirs}")

          copy_file("#{extra_dirs}/_#{partial_name}.html.erb", "#{VIEW_PATH}/#{file_name}/#{extra_dirs}/_#{partial_name}.html.erb")
        else
          copy_file("_#{partial}.html.erb", "#{VIEW_PATH}/#{file_name}/_#{partial}.html.erb")
        end
      else
        directory('', "#{VIEW_PATH}/#{file_name}")
      end
    end
  end
end
