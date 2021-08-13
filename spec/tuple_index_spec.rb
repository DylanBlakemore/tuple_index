require "spec_helper"

RSpec.describe TupleIndex do
  it "has a version number" do
    expect(TupleIndex::VERSION).not_to be nil
  end

  describe ".new" do
    it "creates a new container instance" do
      expect(TupleIndex.new([], [])).to be_a(TupleIndex::Container)
    end
  end
end
