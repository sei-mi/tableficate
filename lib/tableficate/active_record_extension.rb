module Tableficate
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      extend Tableficate::Finder

      self.scope :tableficate_ext, ->{} do
        def tableficate_add_data(key, value)
          @tableficate_data ||= {}
          @tableficate_data[key] = value
        end

        def tableficate_get_data
          @tableficate_data || {}
        end
      end
    end
  end
end
