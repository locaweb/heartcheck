module Heartcheck
  module Controllers
    class HealthCheck < Base
      def index
        Oj.dump({ status: 'ok' })
      end
    end
  end
end
