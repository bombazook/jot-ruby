require 'forwardable'
require 'multi_json'
require 'jot/ruby/version'
require 'jot/ruby/errors'
require 'jot/ruby/utils'
require 'jot/ruby/operation'
require 'jot/ruby/impl'

module Jot
  module Ruby
    class << self
      attr_accessor :impl
      extend Forwardable

      def_delegators :impl, *Jot::Ruby::Impl::Base::DEFAULT_METHODS
    end

    extend Utils::Snippets
    Impl.init
  end
end
