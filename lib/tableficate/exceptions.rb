module Tableficate
  class MissingScope < StandardError; end
  
  module Filter
    class MissingTemplate < StandardError; end
    class UnknownInputType < StandardError; end
  end
end
