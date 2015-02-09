require 'net/telnet'

module Heartcheck
  module Services
    # A service to check with a simple telnet
    # if the route to a host is working.
    class Firewall
      attr_reader :uri, :proxy

      # Sets up the options to firewall.
      #
      # @param params [Hash] a hash with the configurations.
      # @option params [String] :host The domain/Ip
      # @option params [Integer] :port Number of port to check
      # @option params [String] :proxy The uri of your proxy if is required
      # @option params [integer] :timeout (defaults to: 2) Number in seconds
      # @option params [string] :uri You can pass a URI instead a host and port
      #
      # @example
      #   Firewall.new(host: 'domain.com', port: 80)
      #   Firewall.new(host: 'domain.com', port: 80, timeout: 5)
      #   Firewall.new(uri: 'https://domain.com')
      #   Firewall.new(uri: 'https://domain.com', proxy: 'http://proxy.domain.com')
      #
      # @return [void]
      def initialize(params)
        @host    = params[:host]
        @port    = params[:port]
        @proxy   = params[:proxy]
        @timeout = params[:timeout] || 2
        @uri     = URI(params[:url].to_s)
      end

      # format params to use in Telnet
      #
      # @return [Hash] with the config
      #   - Host
      #   - Port
      #   - Timeout
      #   - Proxy - if is seted return a Net::Telnet object
      def params
        params = { 'Host' => host, 'Port' => port, 'Timeout' => @timeout }
        params['Proxy'] = proxy_uri if proxy
        params
      end

      # to get the host or stract from @uri
      #
      # @return [String] the host that is configured
      def host
        @host || uri.host
      end

      # to get the port or stract from @uri
      #
      # @return [Integre] the port that is configured
      def port
        @port || uri.port
      end

      private

      # to get the configured proxy
      #
      # @return [Net::Telnet] an instance with configured proxy
      def proxy_uri
        uri_proxy = URI(proxy)
        ::Net::Telnet.new('Host' => uri_proxy.host, 'Port' => uri_proxy.port, 'Timeout' => @timeout)
      end
    end
  end
end
