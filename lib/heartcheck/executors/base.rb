module Heartcheck
  module Executors
    class Base
      def dispatch(checkers)
        checkers.map do |checker|
          track_and_check(checker)
        end
      end

      def track_and_check(checker)
        started = Time.now
        checker.check.tap do |checked|
          checked[:time] = ((Time.now - started) * 1_000.0)
          Logger.info MultiJson.dump(checked)
        end
      end
    end
  end
end
