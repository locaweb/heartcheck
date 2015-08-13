describe Heartcheck::Checks::WatchFile do
  let(:version) { 'spec/fixtures/files/version.json' }

  subject do
    described_class.new.tap do |config|
      config.add_service(file: version)
    end
  end

  describe '#register' do
    context 'using conditional parameter :if' do
      it 'should register service without :if' do
        expect { subject.add_service(file: version) }.
          to change { subject.services.size }.by(1)
      end

      it 'should register service with valid :if' do
        expect { subject.add_service(if: -> { true }, file: version) }.
          to change { subject.services.size }.by(1)
      end

      it 'shouldnt register service :if is not a proc' do
        expect { subject.add_service(if: 'meeh', file: version) }.
          to change { subject.services.size }.by(0)
      end

      it 'should not register service' do
        expect { subject.add_service(if: -> { false }) }.
          to change { subject.services.size }.by(0)
      end
    end
  end

  describe '#validate' do
    context 'the watched file as no modifications' do
      it 'array errors should be empty' do
        subject.validate
        expect(subject.instance_variable_get(:@errors)).to be_empty
      end
    end

    context 'the watched file have new modifications' do
      it 'array errors should not be empty' do
        allow(subject).to receive(:installed).and_return({bacon: true})
        expect { subject.validate }.
          to change { subject.instance_variable_get(:@errors).size }.
              from(0).to(1)
      end
    end
  end
end
