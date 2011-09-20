module Tablificate
  class Attributes < Hash
    def to_s
      output = self.map{|name, value| "#{name}=\"#{value}\""}.join(' ')
      output = " #{output}" if output.present?
      output
    end
  end
end
