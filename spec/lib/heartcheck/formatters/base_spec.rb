require 'spec_helper'

describe Heartcheck::Formatters::Base do
  subject do
    Heartcheck.setup do |monitor|
    end
    Heartcheck.formatter
  end
  describe "#format" do
    let(:check_01) { { dummy1: { status: :ok } , time: 1100 } }
    let(:check_02) { { dummy2: { status: :ok } , time: 100 } }

    it "when hash_formatter is true" do
      expect(subject.format([check_01,check_02])).to be_eql(
          [{:dummy1=>{:status=>:ok}, :time=>1100},
            {:dummy2=>{:status=>:ok}, :time=>100}])
    end
  end

end
