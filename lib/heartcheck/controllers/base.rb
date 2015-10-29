require 'rack'
require 'oj'

Oj.default_options = { mode: :compat }

module Heartcheck
  module Controllers
    class Base
      def index
        fail NotImplementError
      end

      protected

      def check(who)
        Oj.dump(executor.dispatch(Heartcheck.send("#{who}_checks")))
      end

      private

      def executor
        Heartcheck.executor
      end
    end
  end
end
