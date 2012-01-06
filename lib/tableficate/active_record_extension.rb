module Tableficate
  module ActiveRecordExtension
    module Functions
      attr_accessor :tableficate_data
    end

    extend ActiveSupport::Concern

    included do
      extend Tableficate::Finder

      self.scope :tableficate_ext, ->{} do
        include Functions

        def to_a
          a = super.extend(Functions)

          a.tableficate_data = self.tableficate_data

          a
        end
      end
    end
  end
end
