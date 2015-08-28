module Heartcheck
  module Executors
    class Base
      def dispatch(checkers)
        checkers.map do |checker|
          started = Time.now
          checker.check.tap do |checked|
            checked[:time] = ((Time.now - started) * 1_000.0)
            Logger.info Oj.dump(checked)
          end
        end
      end
    end
  end
end
