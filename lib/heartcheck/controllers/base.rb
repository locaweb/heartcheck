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
        Oj.dump(Heartcheck
                .send("#{who}_checks")
                .map(&:check))
      end
    end
  end
end
