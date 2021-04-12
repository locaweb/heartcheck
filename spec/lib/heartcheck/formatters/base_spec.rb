require 'spec_helper'

describe Heartcheck::Formatters::Base do
  describe "#format" do
    let(:check_01) { {dummy1: {status: :ok}, time: 1100} }
    let(:check_02) { {dummy2: {status: :ok}, time: 100} }

    it "generates a list of with a hashes for every check" do
      expect(subject.format([check_01, check_02])).to be_eql([
        {dummy1: {status: :ok}, time: 1100},
        {dummy2: {status: :ok}, time: 100}
      ])
    end
  end
end
