# frozen_string_literal: true

module Heartcheck
  module Controllers
    class HealthCheck < Base
      def index
        MultiJson.dump({ status: 'ok' })
      end
    end
  end
end
