# frozen_string_literal: true

require 'spec_helper'

describe Heartcheck::Formatters::HashResponse do
  describe '#format' do
    let(:check1) { { dummy1: { status: :ok }, time: 1100 } }
    let(:check2) { { dummy2: { status: :ok }, time: 100 } }

    it 'generates a single hash with every check as a key' do
      expect(subject.format([check1, check2])).to be_eql(
        {
          dummy1: { status: :ok, time: 1100 },
          dummy2: { status: :ok, time: 100 }
        }
      )
    end
  end
end
