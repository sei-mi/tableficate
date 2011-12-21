module Tableficate
  module Utils
    def self.template_path(template, partial, theme = '')
      file = File.join(['tableficate', theme, partial].delete_if(&:blank?))

      file = File.join(['tableficate', partial]) if not theme.blank? and not template.lookup_context.exists?(file, [], true)

      file
    end
  end
end
