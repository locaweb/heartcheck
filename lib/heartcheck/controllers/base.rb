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
        MultiJson.dump(executor.dispatch(Heartcheck.send("#{who}_checks")))
      end

      private

      def executor
        Heartcheck.executor
      end
    end
  end
end
