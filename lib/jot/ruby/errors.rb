module Jot
  module Ruby
    module Errors
      class ImplError < StandardError; end
      class NoImplError < NotImplementedError; end
    end
  end
end
