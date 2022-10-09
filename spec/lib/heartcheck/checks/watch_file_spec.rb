# frozen_string_literal: true

describe Heartcheck::Checks::WatchFile do
  subject do
    described_class.new.tap do |config|
      config.add_service(file: 'spec/fixtures/files/version.json')
    end
  end

  describe '#validate' do
    context 'when the watched file as no modifications' do
      it 'array errors should be empty' do
        subject.validate
        expect(subject.instance_variable_get(:@errors)).to be_empty
      end
    end

    context 'when the watched file have new modifications' do
      it 'array erros should not be empty' do
        allow(subject).to receive(:installed).and_return({ bacon: true })
        expect { subject.validate }
          .to change { subject.instance_variable_get(:@errors).size }
          .from(0).to(1)
      end
    end
  end
end
