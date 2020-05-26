require 'spec_helper'

describe Heartcheck::Services::ResponseFormatter do
  describe "#execute" do
    let(:check_01) { { dummy1: { status: :ok } , time: 1100 } }
    let(:check_02) { { dummy2: { status: :ok } , time: 100 } }
    let(:hash_formatter_true) { described_class.new(true) }
    let(:hash_formatter_false) { described_class.new(false) }
    
    it "when hash_formatter is true" do
      expect(hash_formatter_true.execute([check_01,check_02])).to be_eql(
        {:dummy1=>{:status=>:ok, :time=>1100},
         :dummy2=>{:status=>:ok, :time=>100}})
    end

    it "when hash_formatter is false" do
      expect(hash_formatter_false.execute([check_01,check_02])).to be_eql([
        {:dummy1=>{:status=>:ok}, :time=>1100},
         {:dummy2=>{:status=>:ok}, :time=>100}
         ])
    end
    
  end

end
