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

      def uri_info
        services.map do |s|
          {
            host: s.uri.host,
            port: s.uri.port,
            scheme: s.uri.scheme
          }
        end
      end

      private

      def custom_error(service)
        error_message = "connection refused on: #{service.host}:#{service.port}"

        if service.proxy
          proxy_uri = URI(service.proxy)
          error_message << " via proxy: #{proxy_uri.host}:#{proxy_uri.port}"
        end

        @errors << error_message
      end
    end
  end
end
