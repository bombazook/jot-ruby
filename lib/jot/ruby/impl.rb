module Jot
  module Ruby
    module Impl
      class << self
        def init impl_name=nil
          impl_const = Jot::Ruby.impl_registry[impl_name.to_s]
          impl_const ||= Jot::Ruby.impl_registry.values.first
          raise NoImplError unless impl_const
          ::Jot::Ruby.impl = ImplRoot.new(impl_const)
        end
      end
    end
  end
end
