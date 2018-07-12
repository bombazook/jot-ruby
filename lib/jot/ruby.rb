require 'forwardable'
require 'jot/ruby/version'
require 'jot/ruby/errors'
require 'jot/ruby/utils'
require 'jot/ruby/operation'
require 'jot/ruby/impl_base'

module Jot
  module Ruby
    class << self
      def init(impl_name = nil)
        impl_const = Jot::Ruby.impl_registry[impl_name.to_s]
        impl_const ||= Jot::Ruby.impl_registry.values.first
        raise Errors::NoImplError unless impl_const
        self.impl = impl_const.new
      end

      extend Forwardable
      def_delegators :impl, *Jot::Ruby::ImplBase::DEFAULT_METHODS

      def impl_registry
        @impl_registry ||= {}
      end

      private

      attr_writer :impl

      def impl
        @impl ||= init
      end
    end
  end
end
