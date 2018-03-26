module Jot
  module Ruby
    module Impl
      class << self
        def init
          impl_const = Jot::Ruby::Impl.constants.first
          raise NoImplError unless impl_const
          Jot::Ruby.impl = Jot::Ruby::Impl.const_get(impl_const).new
          Operation.include Jot::Ruby.impl.class::OperationMethods
        end
      end

      class Base
        extend Utils::Snippets
        RAW_METHODS = %i[opFromJSON deserialize diff].freeze

        DEFAULT_OPERATIONS = [
          :NO_OP,                   # Does nothing
          :SET, :LIST,              # General operations
          :MATH,                    # Math
          :SPLICE, :ATINDEX, :MAP,  # Stings and Arrays
          :PUT, :REM, :APPLY,       # Object operations
          :COPY                     # Affect structure
        ].freeze

        DEFAULT_METHODS = RAW_METHODS + DEFAULT_OPERATIONS

        not_implemented DEFAULT_METHODS
      end
    end
  end
end
