require 'heartcheck/caching_app/cache'
require 'concurrent'

module Heartcheck
  class CachingApp
    describe Cache do
      let(:ttl) { 0.1 }
      let(:controllers) do
        3.times.collect do |_|
          Class.new do
            @count = 0

            def self.call_count
              @count ||= 0
            end

            def self.incr
              @count += 1
            end

            def index
              self.class.incr
              '{"current":"ok"}'
            end
          end
        end
      end

      def wait_for_one_execution
        Concurrent::ScheduledTask.execute(ttl) { "waiting the ttl" }.value!
      end

      subject do
        described_class.new(controllers, ttl)
      end

      before do
        # use a blocking executor, no concurrency
        subject.concurrent_opts = {executor: Concurrent::ImmediateExecutor.new}
      end

      describe '#result' do
        it 'returns a blank result on first dispatch' do
          subject.concurrent_opts = {executor: Concurrent::SingleThreadExecutor.new}
          subject.start

          expect(subject.result(controllers.first)).to be_nil
        end

        it 'returns the results after running at least once' do
          subject.start

          wait_for_one_execution

          expect(subject.result(controllers.first)).not_to be_nil
          expect(controllers).to be_all { |c| c.call_count == 1 }
        end

        it 'caches the results (not calling #dispatch on the base executor)' do
          subject.start
          wait_for_one_execution

          subject.result(controllers.first)
          subject.result(controllers.first)

          expect(controllers).to be_all { |c| c.call_count == 1 }
        end

        it 'dispatches again when the ttl expired' do
          subject.start
          wait_for_one_execution
          subject.result(controllers.first)
          wait_for_one_execution

          expect(controllers).to be_all { |c| c.call_count == 2 }
        end
      end
    end
  end
end
