module Tablificate
  class ThemeGenerator < Rails::Generators::NamedBase
    desc('Create a Tablificate theme.')

    VIEW_PATH = 'app/views/tablificate'

    source_root File.expand_path("../../../../../#{VIEW_PATH}", __FILE__)

    def create_theme
      empty_directory(VIEW_PATH)

      directory('', "#{VIEW_PATH}/#{file_name}")
    end
  end
end
