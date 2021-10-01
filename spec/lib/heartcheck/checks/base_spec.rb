# frozen_string_literal: true

require 'spec_helper'

describe Heartcheck::Checks::Base do
  subject(:base) { described_class.new }

  describe '#on_error' do
    context 'with a block' do
      it 'sets error_proc' do
        subject.on_error { |errors| errors << 1 }
        expect(subject.instance_variable_get(:@error_proc)).to be_a(Proc)
      end
    end

    context 'with out a block' do
      it "doesn't set error_proc" do
        subject.on_error
        expect(subject.instance_variable_get(:@error_proc)).to be_nil
      end
    end
  end

  describe '#to_validate' do
    context 'with a block' do
      it 'sets validate_proc' do
        subject.to_validate { |services, errors| errors << services }
        expect(subject.instance_variable_get(:@validate_proc)).to be_a(Proc)
      end
    end

    context 'with out a block' do
      it "doesn't set validate_proc" do
        subject.to_validate
        expect(subject.instance_variable_get(:@validate_proc)).to be_nil
      end
    end
  end

  describe '#register_dynamic_services' do
    context 'with a block' do
      it 'sets dynamic_services' do
        subject.register_dynamic_services { [1, 2, 3] }
        expect(subject.instance_variable_get(:@dynamic_services)).to be_a(Proc)
      end
    end

    context 'with out a block' do
      it "doesn't set dynamic_services" do
        subject.register_dynamic_services
        expect(subject.instance_variable_get(:@dynamic_services)).to be_nil
      end
    end
  end

  describe '#add_service' do
    it 'adds service to services' do
      subject.add_service(1)
      expect(subject.services).to eq([1])
    end
  end

  describe '#services' do
    before do
      subject.add_service(1)
    end

    context 'with dynamic_services' do
      it 'returns all services' do
        subject.register_dynamic_services { [2, 3] }
        expect(subject.services).to match_array([1, 2, 3])
      end
    end

    context 'without dynamic_services' do
      it 'returns default services' do
        expect(subject.services).to match_array([1])
      end
    end
  end

  describe '#functional?' do
    context 'default is false' do
      describe '#functional?' do
        subject { super().functional? }
        it { is_expected.to be_falsey }
      end
    end

    context 'can change value' do
      before { base.functional = true }

      describe '#functional?' do
        subject { super().functional? }
        it { is_expected.to be_truthy }
      end
    end
  end

  describe '#dev?' do
    context 'default is false' do
      describe '#dev?' do
        subject { super().dev? }
        it { is_expected.to be_falsey }
      end
    end

    context 'can change value' do
      before { base.dev = true }

      describe '#dev?' do
        subject { super().dev? }
        it { is_expected.to be_truthy }
      end
    end
  end

  describe '#check' do
    before { allow(Heartcheck.logger).to receive(:info) }

    context 'with success' do
      before { allow(subject).to receive(:validate) }
      it 'returns empty array' do
        expect(subject.check).to eq('base' => { 'status' => 'ok' })
      end
    end

    context 'with errors' do
      subject do
        described_class.new.tap do |c|
          c.to_validate do |_services, errors|
            errors << 'reaching'
          end
        end
      end

      it 'returns the errors' do
        expect(subject.check).to eq(
          'base' => {
            'status' => 'error',
            'message' => [{ type: 'error', message: 'reaching', doc_url: nil }]
          }
        )
      end

      it 'should not accumulate errors' do
        subject.check
        expect(subject.check).to eq(
          'base' => {
            'status' => 'error',
            'message' => [{ type: 'error', message: 'reaching', doc_url: nil }]
          }
        )
      end

      it 'shows the doc_url if present' do
        # setup
        doc_url = 'http://lala.com/docs/monitoring'
        check_item = described_class.new
        check_item.to_validate do |_services, errors|
          errors << 'reaching'
        end
        check_item.doc_url = doc_url

        # exercise
        result = check_item.check

        # verify
        expect(result).to eq(
          'base' => {
            'status' => 'error',
            'message' => [
              {
                type: 'error',
                message: 'reaching',
                doc_url: doc_url
              }
            ]
          }
        )
      end
    end
  end

  describe '#informations' do
    context 'with error' do
      before do
        allow(subject).to receive(:info).and_raise('some error')
      end

      it 'returns show an error' do
        expect(subject.informations).to eq('error' => 'some error')
      end
    end

    context 'without error' do
      let(:response) { { 'version' => '1234' } }
      before do
        allow(subject).to receive(:info).and_return(response)
      end

      it 'should show a response' do
        expect(subject.informations).to eq(response)
      end
    end
  end

  describe '#uri_info' do
    context 'for the base class' do
      it 'returns a hash with an error message' do
        expect(subject.uri_info).to include(:error)
        expect(subject.uri_info).not_to include(:host)
        expect(subject.uri_info).not_to include(:port)
        expect(subject.uri_info).not_to include(:schema)
      end
    end
  end
end
