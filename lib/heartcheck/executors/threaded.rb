# frozen_string_literal: true

module Heartcheck
  module Executors
    class Threaded < Heartcheck::Executors::Base
      def dispatch(checkers)
        checkers.collect do |checker|
          Concurrent::Future.execute { track_and_check(checker) }
        end.collect(&:value)
      end
    end
  end
end
