require 'securerandom'

module Jot
  module Ruby
    class ImplBase
      class << self
        attr_reader :registry_key

        def registry_key=(new_name)
          old_name = @registry_key
          @registry_key = new_name.to_s
          ::Jot::Ruby.impl_registry[@registry_key] = self
          ::Jot::Ruby.impl_registry.delete old_name
        end

        def inherited(base)
          super
          base.prepend Prepender
          base.registry_key = SecureRandom.hex
          ::Jot::Ruby.impl_registry[base.registry_key] = base
        end
      end

      def self.operation_class
        @operation_class ||= begin
          klass = Class.new(Operation)
          if self.constants.include? :OperationMethods
            klass.include self::OperationMethods
          else
            raise Errors::NoImplError, "impl has no OperationMethods module"
          end
          klass.prepend Operation::OriginalOperationMethods
          klass
        end
      end

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

      extend Utils::Snippets
      not_implemented *DEFAULT_METHODS

      module Prepender
        DEFAULT_METHODS.each do |method_name|
          define_method method_name do |*args|
            self.class.operation_class.new(super(*args))
          end
        end
      end
    end
  end
end
