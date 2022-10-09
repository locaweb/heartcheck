# frozen_string_literal: true

describe Heartcheck do
  let(:essential)  { Heartcheck::Checks::Base.new }
  let(:functional) { Heartcheck::Checks::Base.new.tap { |c| c.functional = true } }
  let(:info)       { Heartcheck::Checks::Base.new.tap { |c| allow(c).to receive(:info) } }
  let(:path)       { 'app/version.json' }

  describe '#logger' do
    context 'with default' do
      it 'returns a Logger' do
        described_class.setup do |monitor|
          expect(monitor.logger).to be_a(Logger)
        end
      end
    end

    context 'with custom' do
      it 'returns a custom loggger' do
        described_class.logger = 'lala'
        expect(described_class.logger).to be_a(String)
      end
    end
  end

  describe '#format' do
    context 'with default' do
      before(:each) { described_class.instance_variable_set :@formatter, nil }
      it 'returns a Heartcheck::Formatters::Base' do
        described_class.setup do |monitor|
          expect(monitor.formatter).to be_a(Heartcheck::Formatters::Base)
        end
      end
    end

    context 'with hash formatter' do
      before(:each) { described_class.instance_variable_set :@formatter, nil }
      it 'returns a Heartcheck::Formatters::Base' do
        described_class.setup do |monitor|
          described_class.use_hash_formatter!
          expect(monitor.formatter).to be_a(Heartcheck::Formatters::HashResponse)
        end
      end
    end
  end

  describe '#executor' do
    context 'with default' do
      it 'returns a Heartcheck::Executors::Base' do
        described_class.setup do |monitor|
          expect(monitor.executor).to be_a(Heartcheck::Executors::Base)
        end
      end
    end

    context 'with custom' do
      it 'returns a custom custom executor' do
        described_class.executor = 'lala'
        expect(described_class.executor).to be_a(String)
      end
    end

    context 'with threaded' do
      it 'returns a threaded  executor' do
        described_class.use_threaded_executor!
        expect(described_class.executor).to be_a(Heartcheck::Executors::Threaded)
      end
    end
  end

  describe '#essential_checks' do
    before { described_class.checks = [essential, functional] }

    it 'returns just essential checks' do
      expect(described_class.essential_checks).to eq([essential])
    end
  end

  describe '#functional_checks' do
    before { described_class.checks = [essential, functional] }

    it 'returns just functional checks' do
      expect(described_class.functional_checks).to eq([functional])
    end
  end

  describe '#info_checks' do
    before { described_class.checks = [info, essential] }

    it 'returns just info checks' do
      expect(described_class.info_checks).to eq([info])
    end
  end

  describe '#add' do
    subject(:add) { described_class.add(name, &blk) }

    let(:name) { :process }
    let(:blk) { ->(c) { c.this_is_terrible } }
    let(:plugin) { Heartcheck::Checks::Process.new }

    let(:blk) { ->(_) {} }

    before do
      allow(Heartcheck::Checks::Process).to receive(:new)
        .and_return(plugin)
      allow(plugin).to receive(:this_is_terrible)
    end

    it 'returns the built instance' do
      is_expected.to eq([plugin])
    end

    it 'adds to context list' do
      add

      expect(described_class.checks).to contain_exactly(
        plugin
      )
    end


    it 'instantiates the class passing the given block' do
      expect(plugin).to receive(:this_is_terrible)

      add
    end
  end
end
