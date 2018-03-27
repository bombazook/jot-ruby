require 'securerandom'
module Jot
  module Ruby
    module Utils
      module ImplTools
        attr_reader :registry_key

        class << self
          def extended base
            base.registry_key = SecureRandom.hex
            ::Jot::Ruby.impl_registry[base.registry_key] = base
          end
        end

        def registry_key= new_name
          old_name = @registry_key
          @registry_key = new_name.to_s
          ::Jot::Ruby.impl_registry[@registry_key] = self
          ::Jot::Ruby.impl_registry.delete old_name
        end
      end
    end
  end
end
