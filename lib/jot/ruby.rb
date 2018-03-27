require 'forwardable'
require 'jot/ruby/version'
require 'jot/ruby/errors'
require 'jot/ruby/utils'
require 'jot/ruby/impl_root'
require 'jot/ruby/operation'
require 'jot/ruby/impl'

module Jot
  module Ruby
    class << self
      attr_writer :impl

      def impl
        @impl ||= Jot::Ruby::Impl.init
      end

      extend Forwardable
      def_delegators :impl, *Jot::Ruby::ImplRoot::DEFAULT_METHODS


      def impl_registry
        @impl_registry ||= {}
      end
    end
  end
end
