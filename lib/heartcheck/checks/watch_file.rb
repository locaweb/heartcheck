require 'json'

module Heartcheck
  module Checks
    class WatchFile < Base
      def add_service(service)
        checker = service[:if]

        if checker.nil? || (checker.is_a?(Proc) && checker.call)
          services << service.merge(runtime: installed(service[:file]))
        end
      end

      def validate
        services.each do |service|
          if not service[:runtime].eql? installed(service[:file])
            @errors << "App outdated, check info route"
          end
        end
      end

      def info
        services.collect do |service|
          { runtime: service[:runtime], installed: installed(service[:file]) }
        end
      end

      private

      def installed(file)
        JSON.parse open(file).read
      end
    end
  end
end
