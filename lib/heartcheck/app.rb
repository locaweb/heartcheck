require 'rack'
require 'heartcheck/controllers/base'

Dir.glob(File.expand_path('../controllers/*.rb', __FILE__))
  .each { |x| require x }

# A web app that's use rack
module Heartcheck
  class App
    # A hash with paths as keys and controllers
    # as values we use it in #dispath_action
    # to routes the requests
    ROUTE_TO_CONTROLLER = {
      '/' => Controllers::Essential,
      '' => Controllers::Essential,
      '/functional' => Controllers::Functional,
      '/dev' => Controllers::Dev,
      '/info' => Controllers::Info,
      '/inspect' => Controllers::Inspect,
      '/health_check' => Controllers::HealthCheck,
      '/environment' => Controllers::Environment
    }

    # Sets up the rack application.
    #
    # @param app [RackApp] is a rack app where
    #   heartcheck is included.
    #
    # @return [void]
    def initialize(app = nil)
      @app = app
    end

    # Sets up the rack application.
    #
    # @param env [Hash] is an instance of Hash
    #   that includes CGI-like headers.
    #
    # @return [Array] must be an array that contains
    #   - The HTTP response code
    #   - A Hash of headers
    #   - The response body, which must respond to each
    def call(env)
      req = Rack::Request.new(env)

      [200, { 'Content-Type' => 'application/json' }, [dispatch_action(req)]]
    rescue Heartcheck::Errors::RoutingError
      [404, { 'Content-Type' => 'application/json' }, ['Not found']]
    end

    private

    # Find a controller to espefic path
    #   and call the index method
    #
    # @param req [Rack::Request] an instance of request
    #
    # @return [String] a response body
    def dispatch_action(req)
      controller = ROUTE_TO_CONTROLLER[req.path_info]
      fail Heartcheck::Errors::RoutingError if controller.nil?

      Logger.info "Start [#{controller}] from #{req.ip} at #{Time.now}"

      controller.new.index.tap do |_|
        Logger.info "End [#{controller}]\n"
      end
    end
  end
end
