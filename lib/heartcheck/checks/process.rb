module Heartcheck
  module Checks
    class Process < Base
      def validate
        services.each do |service|
          begin
            pid = get_pid(service)
            ::Process.kill(0, pid)
          rescue Errno::ESRCH
            append_error(service, pid)
          end
        end
      end

      private

      def custom_error(service, pid)
        @errors << "The process of #{service[:name]} is not run with pid #{pid}"
      end

      def get_pid(service)
        if service[:pid]
          service[:pid]
        else
          File.read(service[:file]).to_i
        end
      end
    end
  end
end
