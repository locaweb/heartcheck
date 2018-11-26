module Heartcheck
  module Controllers
    class Inspect < Base
      def index
        results = {
          application_name: application_name,
          environment: environment,
          dependencies: []
        }

        checks = Heartcheck.checks
        results[:dependencies] += checks.reduce([]) do |acc, elem|
          acc << elem.uri_info
        end.flatten

        MultiJson.dump(results)
      end

      private

      def application_name
        ENV.fetch('HEARTCHECK_APP_NAME')
      end

      def environment
        ENV.fetch('RAILS_ENV')
      end
    end
  end
end
