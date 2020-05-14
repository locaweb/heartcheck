module Heartcheck
    module Executors
      class HashResponse
        def dispatch(checkers)
            checkers.map do |checker|
              track_and_check(checker)
            end.reduce({}, :merge)
        end

        def track_and_check(checker)
          started = Time.now
          checker.check.tap do |checked|
            value = checked.values.first.merge(time:((Time.now - started) * 1_000.0))
            checked.merge!(Hash[checked.keys.first => value])
            Logger.info MultiJson.dump(checked)
          end
        end
    end
  end
end