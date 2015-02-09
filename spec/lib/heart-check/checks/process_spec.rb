require 'spec_helper'

describe Heartcheck::Checks::Process do
  let(:opts) { { name: 'worker', file: 'spec/fixtures/files/worker.pid' } }
  subject    { described_class.new.tap { |c| c.add_service(opts) } }

  describe '#validate' do
    context 'with success' do
      it 'calls process kill 0' do
        expect(Process).to receive(:kill).with(0, -111_111)
        subject.validate
        expect(subject.instance_variable_get(:@errors)).to be_empty
      end
    end

    context 'with error' do
      before do
        allow(Process).to receive(:kill).and_raise(Errno::ESRCH)
      end

      it 'sets default error' do
        error_message = 'The process of worker is not run with pid -111111'
        subject.validate
        expect(subject.instance_variable_get(:@errors)).to match_array([error_message])
      end

      it 'uses custom error message' do
        error_message = 'worker is not run with pid -111111'

        subject.on_error do |errors, service, pid|
          errors << "#{service[:name]} is not run with pid #{pid}"
        end
        subject.validate

        expect(subject.instance_variable_get(:@errors)).to match_array([error_message])
      end
    end
  end
end
