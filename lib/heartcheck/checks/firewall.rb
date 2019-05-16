module Heartcheck
  module Checks
    class Firewall < Base
      def services
        super.map { |opts| Services::Firewall.new(opts) }
      end

      def validate
        services.each do |service|
          begin
            Net::Telnet.new(service.params).close
          rescue Errno::ECONNREFUSED; nil
          rescue
            append_error(service)
          end
        end
      end

      def uri_info
        services.map do |service|
          {
            host: service.host,
            port: service.port,
            scheme: service.uri.scheme || ''
          }
        end
      end

      private

      def custom_error(service)
        error_message = "connection refused on: #{service.host}:#{service.port}"

        if service.proxy
          proxy_uri = URI(service.proxy)
          error_message << " using proxy: #{proxy_uri.host}:#{proxy_uri.port}"
        end

        @errors << error_message
      end
    end
  end
end
