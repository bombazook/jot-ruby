module Jot
  module Ruby
    module Impl
      class << self
        def init
          if Jot::Ruby::Impl.const_defined? :Native
            Jot::Ruby.impl = Jot::Ruby::Impl::Native.new
          else
            require 'jot/ruby/impl/js'
            Jot::Ruby.impl = Jot::Ruby::Impl::Js.new
          end
          raise NotImplementedError unless Jot::Ruby.impl
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
