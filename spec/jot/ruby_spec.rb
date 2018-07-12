require 'spec_helper'

RSpec.describe Jot::Ruby do
  it "raises a NoImplError if no impl registered" do
    expect{subject.diff}.to raise_error(Jot::Ruby::Errors::NoImplError)
  end

  it "has a version number" do
    expect(Jot::Ruby::VERSION).not_to be nil
  end
end
