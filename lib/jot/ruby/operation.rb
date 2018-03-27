module Jot
  module Ruby
    class Operation < SimpleDelegator
      RAW_RESULT_METHODS = %i[isNoOp toJSON apply serialize inspect].freeze
      OPERATION_RESULT_METHODS = %i[simplify drilldown compose rebase].freeze
      DEFAULT_METHODS = RAW_RESULT_METHODS + OPERATION_RESULT_METHODS

      extend Utils::Snippets
      not_implemented DEFAULT_METHODS

      module Prepender
        OPERATION_RESULT_METHODS.each do |method_name|
          define_method method_name do |*args|
            self.class.new(super(*args))
          end
        end

        RAW_RESULT_METHODS.each do |method_name|
          define_method method_name do |*args|
            super(*args)
          end
        end
      end
    end
  end
end
