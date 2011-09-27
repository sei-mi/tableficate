module Tablificate
  module Utils
    def self.template_path(template, theme = '')
      ['tablificate', theme, template].delete_if(&:blank?).join('/')
    end
  end
end
