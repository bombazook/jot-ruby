require 'spec_helper'

RSpec.describe Jot::Ruby::ImplBase do
  context "no OperationMethods in implementation" do
    let(:impl_class){ Class.new(Jot::Ruby::ImplBase) }

    describe ".operation_class" do
      it "raises NoImplError" do
        expect{ impl_class.operation_class }.to raise_error(Jot::Ruby::Errors::NoImplError)
      end
    end

    describe ".inherited" do
      it "sets some value at impl registry to impl class" do
        expect(Jot::Ruby.impl_registry).to have_value(impl_class)
      end
    end

    it "does not raise error during inheritance" do
      expect{ impl_class }.not_to raise_error
    end
  end

  context "OperationMethods given" do
    let(:impl_class) do
      Class.new(Jot::Ruby::ImplBase) do
        const_set(:OperationMethods, Module.new)
      end
    end

    describe ".operation_class" do
      it "raises no errors if implementation has OperationMethods module" do
        expect{ impl_class.operation_class }.not_to raise_error
      end
    end

    described_class::DEFAULT_METHODS.each do |mname|
      context "##{mname} has implementation" do
        let!(:method_impl) do
          impl_class.class_eval do
            define_method(mname) do
              nil
            end
          end
        end
        it "##{mname} call returns operation_class instance" do
          expect(impl_class.new.send(mname)).to be_instance_of(impl_class.operation_class)
        end
      end

      context "##{mname} has no implementation" do
        it "##{mname} call raises NotImplementedError" do
          expect{impl_class.new.send(mname)}.to raise_error(NotImplementedError)
        end
      end
    end

  end
end
