# frozen_string_literal: true

module Heartcheck
  module Controllers
    class Inspect < Base
      def index
        results = {
          application_name: application_name,
          dependencies: []
        }

        checks = Heartcheck.checks
        results[:dependencies] += checks.reduce([]) do |acc, elem|
          acc << elem.uri_info
        end.flatten.uniq

        MultiJson.dump(results)
      end

      private

      def application_name
        ENV.fetch('HEARTCHECK_APP_NAME')
      end
    end
  end
end
