module Tableficate
  module Utils
    def self.template_path(template, theme = '')
      ['tableficate', theme, template].delete_if(&:blank?).join('/')
    end
  end
end
