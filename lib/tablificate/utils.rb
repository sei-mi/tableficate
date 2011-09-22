module Tablificate
  module Utils
    def self.template_path(template, theme = '')
      ['tablificate', theme, template].delete_if{|x| x.blank?}.join('/')
    end
  end
end
