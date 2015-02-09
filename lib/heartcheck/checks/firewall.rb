module Heartcheck
  module Checks
    class Firewall < Base
      def services
        super.map { |opts| Services::Firewall.new(opts) }
      end

      def validate
        services.each do |service|
          begin
            Net::Telnet.new(service.params)
          rescue Errno::ECONNREFUSED; nil
          rescue
            append_error(service)
          end
        end
      end

      private

      def custom_error(service)
        @errors << "connection refused on: #{service.host}:#{service.port}"
      end
    end
  end
end
