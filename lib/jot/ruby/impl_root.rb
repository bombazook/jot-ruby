module Jot
  module Ruby
    class ImplRoot
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

      def initialize impl_module
        @impl_module = impl_module
        self.extend impl_module::RootMethods
        self.singleton_class.prepend Prepender
      end

      def operation_class
        @operation_class ||= begin
          klass = Class.new(Operation)
          klass.include @impl_module::OperationMethods
          klass.prepend Operation::Prepender
          klass
        end
      end

      extend Utils::Snippets
      not_implemented DEFAULT_METHODS

      module Prepender
        DEFAULT_METHODS.each do |method_name|
          define_method method_name do |*args|
            operation_class.new(super(*args))
          end
        end
      end

    end
  end
end
