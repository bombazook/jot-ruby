module Jot
  module Ruby
    class Operation < SimpleDelegator
      RAW_RESULT_METHODS = %i[isNoOp toJSON apply serialize inspect].freeze
      OPERATION_RESULT_METHODS = %i[simplify drilldown compose rebase].freeze
      DEFAULT_METHODS = RAW_RESULT_METHODS + OPERATION_RESULT_METHODS

      extend Utils::Snippets
      not_implemented *DEFAULT_METHODS

      module OriginalOperationMethods
        OPERATION_RESULT_METHODS.each do |method_name|
          class_eval <<-EOS
            def #{method_name} *args
              self.class.new(super(*args))
            end
          EOS
        end
      end
    end
  end
end
