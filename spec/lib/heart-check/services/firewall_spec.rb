require 'spec_helper'

describe Heartcheck::Services::Firewall do
  describe '#params' do
    context 'with host and port' do
      subject { described_class.new(host: 'test.com', port: 22) }

      it 'returns a hash' do
        expect(subject.params).to eq('Host' => 'test.com', 'Port' => 22, 'Timeout' => 2)
      end
    end

    context 'with url' do
      subject { described_class.new(url: 'https://test.com') }

      it 'returns a hash' do
        expect(subject.params).to eq('Host' => 'test.com', 'Port' => 443, 'Timeout' => 2)
      end
    end

    context 'with timeout' do
      subject { described_class.new(host: 'test.com', port: 22, timeout: 10) }

      it 'returns a hash' do
        expect(subject.params).to eq('Host' => 'test.com', 'Port' => 22, 'Timeout' => 10)
      end
    end

    context 'with proxy' do
      subject { described_class.new(host: 'test.com', port: 22, proxy: 'http://locaweb.com.br') }

      it 'returns a hash' do
        expect(Net::Telnet).to receive(:new).with('Host' => 'locaweb.com.br', 'Port' => 80, 'Timeout' => 2)
        subject.params
      end
    end
  end
end
