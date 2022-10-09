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

        it 'registers a log entry for each checker' do
          expect(Logger).to receive(:info).exactly(registered).times
          subject.dispatch(checkers)
        end

        it 'has a :time key in the checker response' do
          expect(subject.dispatch(checkers)).to all(include(:time))
        end

        it 'has a float value (time key)' do
          subject.dispatch(checkers).each do |current|
            expect(current[:time]).to be_a(Float)
          end
        end
      end
    end
  end
end
