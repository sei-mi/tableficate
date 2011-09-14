module Tablificate
  class Base
    def self.scope(model)
      @model = model.to_s.camelize.constantize
    end

    def self.find_by_params(*params)
      @model.all
    end
  end
end
