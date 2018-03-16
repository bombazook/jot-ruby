require 'execjs'

module Jot
  module Ruby
    module Impl
      class Js < Base
        class << self
          def runtime
            @runtime ||= begin
              source = File.read(File.join(Jot::Ruby.gem_root, 'build/jot.js'))
              ExecJS.compile(source)
            end
          end
        end

        module ImplHelpers
          private

          def js_eval(str = nil)
            if block_given?
              val = yield
              Js.runtime.eval(val)
            elsif str
              Js.runtime.eval(str)
            end
            rescue ExecJS::ProgramError => e
              raise Errors::ImplError, e.message
          end

          def js_method(method_name, *args)
            "#{method_name}(#{transform_args(*args)})"
          end

          def js_operation_method(op, method_name, *args)
            "#{raw_op(op)}.#{js_method(method_name, *args)}"
          end

          def js_jot_method(method_name, *args)
            "jot.#{js_method(method_name, *args)}"
          end

          def raw_op(op)
            "jot.deserialize(#{escape(op.serialized)})"
          end

          def serialize_op
            "(#{yield}).serialize()"
          end

          def serialized_jot_eval(method_name, *args)
            js_eval do
              serialize_op do
                js_jot_method(method_name, *args)
              end
            end
          end

          def new_serialized_jot_eval(method_name, *args)
            js_eval do
              serialize_op do
                ["new", js_jot_method(method_name, *args)].join(' ')
              end
            end
          end

          def escape str
            ::JSON.generate(str, quirks_mode: true, max_nesting: false)
          end

          def transform_args(*args)
            args.map! do |arg|
              case arg
              when Hash
                MultiJson.dump(arg)
              when Operation
                raw_op(arg)
              when Numeric
                arg
              when Array
                "[#{arg.flat_map{|i| transform_args(i)}.join(', ')}]"
              else
                escape(arg)
              end
            end
            args.join(', ')
          end
        end

        include ImplHelpers

        RAW_METHODS.each do |method_name|
          define_method method_name do |*args|
            Operation.new(serialized_jot_eval(method_name, *args))
          end
        end

        DEFAULT_OPERATIONS.each do |method_name|
          define_method method_name do |*args|
            Operation.new(new_serialized_jot_eval(method_name, *args))
          end
        end

        module OperationMethods
          include ImplHelpers

          Jot::Ruby::Operation::RAW_RESULT_METHODS.each do |method_name|
            define_method method_name do |*args|
              js_eval do
                js_operation_method self, method_name, *args
              end
            end
          end

          Jot::Ruby::Operation::OPERATION_RESULT_METHODS.each do |method_name|
            define_method method_name do |*args|
              js_eval do
                serialize_op do
                  js_operation_method self, method_name, *args
                end
              end
            end
          end

          def serialized
            __getobj__
          end

          def inspect
            toJSON
          end
        end
      end
    end
  end
end
