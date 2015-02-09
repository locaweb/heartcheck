require 'spec_helper'

describe Heartcheck::Logger do
  describe '.debug' do
    it 'send message to defined logger' do
      expect(Heartcheck.logger).to receive(:debug).with('[Heartcheck] lala')
      described_class.debug('lala')
    end
  end

  describe '.info' do
    it 'send message to defined logger' do
      expect(Heartcheck.logger).to receive(:info).with('[Heartcheck] lala')
      described_class.info('lala')
    end
  end

  describe '.warn' do
    it 'send message to defined logger' do
      expect(Heartcheck.logger).to receive(:warn).with('[Heartcheck] lala')
      described_class.warn('lala')
    end
  end

  describe '.error' do
    it 'send message to defined logger' do
      expect(Heartcheck.logger).to receive(:error).with('[Heartcheck] lala')
      described_class.error('lala')
    end
  end
end
