module Tablificate
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      self.scope :tablificate_ext, ->{} do
        def tablificate_add_data(key, value)
          @tablificate_data ||= {}
          @tablificate_data[key] = value
        end

        def tablificate_get_data
          @tablificate_data
        end
      end
    end
  end
end
