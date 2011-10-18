module Tableficate
  module Utils
    def self.template_path(template, theme = '')
      File.join(['tableficate', theme, template].delete_if(&:blank?))
    end
  end
end
