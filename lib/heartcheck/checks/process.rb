# frozen_string_literal: true

module Heartcheck
  module Checks
    class Process < Base
      def validate
        services.each do |service|
          pid = get_pid(service)
          ::Process.kill(0, pid)
        rescue Errno::ESRCH
          append_error(service, pid)
        end
      end

      private

      def custom_error(service, pid)
        @errors << "The process of #{service[:name]} is not run with pid #{pid}"
      end

      def get_pid(service)
        service[:pid] || File.read(service[:file]).to_i
      end
    end
  end
end
