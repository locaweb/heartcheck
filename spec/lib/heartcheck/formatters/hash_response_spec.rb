require 'spec_helper'

describe Heartcheck::Formatters::HashResponse do
  describe "#format" do
    let(:check_01) { {dummy1: {status: :ok}, time: 1100} }
    let(:check_02) { {dummy2: {status: :ok}, time: 100} }

    it "generates a single hash with every check as a key" do
      expect(subject.format([check_01, check_02])).to be_eql({
        dummy1: {status: :ok, time: 1100},
        dummy2: {status: :ok, time: 100}
      })
    end
  end
end
