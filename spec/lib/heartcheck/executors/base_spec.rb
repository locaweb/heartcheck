# frozen_string_literal: true

module Heartcheck
  module Executors
    describe Base do
      subject { described_class.new }

      describe '#dispatch' do
        let(:registered) { 3 }

        let(:checkers) do
          registered.times.collect do |_current|
            double.tap do |checker|
              expect(checker).to receive(:check).and_return({ current: 'ok' })
            end
          end
        end

        it 'should register a log entry for each checker' do
          expect(Logger).to receive(:info).exactly(registered).times
          subject.dispatch(checkers)
        end

        it 'should have a :time key in the checker response' do
          subject.dispatch(checkers).each do |current|
            expect(current).to include(:time)
          end
        end

        it 'should have a float value (time key)' do
          subject.dispatch(checkers).each do |current|
            expect(current[:time]).to be_a(Float)
          end
        end
      end
    end
  end
end
