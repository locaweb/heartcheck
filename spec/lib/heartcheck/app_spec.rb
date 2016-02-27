require 'spec_helper'
require 'rack/test'

describe Heartcheck::App do
  include Rack::Test::Methods

  let(:app) { described_class.new }
  subject   { last_response }

  describe '#body' do
    subject { super().body }

    before { get '/' }

    it { is_expected.to eq('[]') }
  end

  describe '#status' do
    subject { super().status }

    before { get '/' }

    it { is_expected.to eq(200) }
  end

  context 'on GET /functional' do
    before { get '/functional' }

    describe '#body' do
      subject { super().body }
      it { is_expected.to eq('[]') }
    end

    describe '#status' do
      subject { super().status }
      it { is_expected.to eq(200) }
    end
  end

  context 'on GET /dev' do
    before do
      Heartcheck.setup do |monitor|
        log = Logger.new(STDOUT)
        log.level = 4
        monitor.logger = log
        monitor.add :base do |c|
          c.name = "check"
        end
      end
      get '/dev'
    end

    it 'has execution_time' do
      expect(subject.body).to match(/"execution_time":"([0-9]{1,2}).([0-9]{2}) ms"/)
    end
    it 'has total_execution_time' do
      expect(subject.body).to match(/"total_execution_time":"([0-9]{1,2}).([0-9]{2}) ms"/)
    end

    describe '#status' do
      subject { super().status }
      it { is_expected.to eq(200) }
    end
  end

  context 'on GET info' do
    before { get '/info' }

    describe '#body' do
      subject { super().body }
      it { is_expected.to eq('[]') }
    end

    describe '#status' do
      subject { super().status }
      it { is_expected.to eq(200) }
    end
  end

  context 'on GET health_check' do
    before { get '/health_check' }

    describe '#body' do
      subject { super().body }
      it { is_expected.to eq(MultiJson.dump({ status: 'ok' })) }
    end

    describe '#status' do
      subject { super().status }
      it { is_expected.to eq(200) }
    end
  end

  context 'on GET other routes' do
    before { get '/lorem' }

    describe '#body' do
      subject { super().body }
      it { is_expected.to eq('Not found') }
    end

    describe '#status' do
      subject { super().status }
      it { is_expected.to eq(404) }
    end
  end
end
