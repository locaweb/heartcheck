# frozen_string_literal: true

module Heartcheck
  module Controllers
    class Dev < Base
      def index
        results = []

        total_execution_time = time_diff do
          checks = Heartcheck.dev_checks

          results += checks.reduce([]) do |acc, elem|
            context_result = {}

            context_result['execution_time'] = time_diff do
              context_result.merge!(elem.check)
            end

            acc << context_result
          end
        end

        results << { 'total_execution_time' => total_execution_time }
        MultiJson.dump(results)
      end

      private

      def time_diff
        start_time = Time.now
        yield
        format('%.2f ms', ((Time.now - start_time) * 1_000))
      end
    end
  end
end
