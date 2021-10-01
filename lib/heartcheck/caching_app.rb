# frozen_string_literal: true

require 'heartcheck/caching_app/cache'

# A rack middleware to wrap around {Heartcheck::App} in a cache
#   Mount an instance of this class passing an app or `use` this in Rack.
#   This accepts an optional ttl for the cache that defaults to 300 seconds.
module Heartcheck
  class CachingApp
    # Creates an instance of the middleware
    #
    # @param app [Heartcheck:App] the Rack app to wrap around
    # @param ttl [Integer] the time to cache the results in seconds
    # @param cache [Heartcheck::CachingApp::Cache] the cache instance to use
    #   The cache will be created on first use if not supplied
    #
    # @return [#call] rack compatible middleware
    def initialize(app, ttl = 300, cache = nil)
      @app = app
      @ttl = ttl
      @cache = cache
    end

    # Invokes the middleware
    #
    # @param env [Hash] the rack request/environment
    # @return [Array] a rack compatible response
    def call(env)
      req = Rack::Request.new(env)
      controller = Heartcheck::App::ROUTE_TO_CONTROLLER[req.path_info]

      if controller && (result = cache.result(controller))
        [200, { 'Content-type' => 'application/json' }, [result]]
      else
        @app.call(env)
      end
    end

    protected

    def cache
      @cache ||= start_cache(@ttl)
    end

    def start_cache(ttl)
      Heartcheck::CachingApp::Cache.new(Heartcheck::App::ROUTE_TO_CONTROLLER
        .values.uniq, ttl).tap(&:start)
    end
  end
end
