module Heartcheck
  module Controllers
    class Inspect < Base
      def index
        results = {
          application_name: Rails.application.class.name,
          environment: ENV['RAILS_ENV'],
          dependencies: []
        }

        checks = Heartcheck.checks
        results[:dependencies] += checks.reduce([]) do |acc, elem|
          acc << elem.uri_info
        end.flatten

        MultiJson.dump(results)
      end
    end
  end
end
