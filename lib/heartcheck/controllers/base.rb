require 'rack'
require 'multi_json'

Oj.default_options = { mode: :compat } if defined?(Oj)

module Heartcheck
  module Controllers
    class Base
      def index
        fail NotImplementError
      end

      protected

      def check(who)
        checks = executor.dispatch(Heartcheck.send("#{who}_checks"))
        MultiJson.dump(formatter.format(checks))
      end

      private
      def formatter
        Heartcheck.formatter
      end

      def executor
        Heartcheck.executor
      end
    end
  end
end
