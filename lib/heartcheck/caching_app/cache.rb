require 'concurrent'

module Heartcheck
  class CachingApp
    # This cache performs the given controllers in background threads.
    #   The public interface always queries the results from the cache.
    #
    # @param executor [Array<Class>] the collection controllers classes to cache
    # @param ttl [Integer] the cache ttl in seconds
    #
    # @return [Heartcheck::CachingApp::Cache]
    class Cache
      attr_accessor :concurrent_opts

      def initialize(controllers, ttl)
        @results = Concurrent::Map.new
        @controllers = controllers
        @ttl = ttl
        @concurrent_opts = {}
      end

      # Fetches the current result for the given controller
      #
      # @param controller [Class] the controller to fetch the current result of
      #
      # @return [String] the result of the index action
      def result(controller)
        @results[controller]
      end

      def start
        schedule(@ttl, &perform_all_controllers)
      end

      protected

      def perform_controller(controller)
        proc do
          Logger.info("Start [#{controller}] for caching at #{Time.now}")
          @results[controller] = controller.new.index
          Logger.info("End [#{controller}]\n")
        end
      end

      def perform_all_controllers
        proc do
          Logger.info("performing all #{@controllers.length} checks")

          tasks = @controllers.map do |controller|
            schedule(0, &perform_controller(controller))
          end

          # wait for all tasks to complete before scheduling next run
          tasks.map(&:value)

          schedule(@ttl, &perform_all_controllers)
        end
      end

      def schedule(ttl, &block)
        Concurrent::ScheduledTask.execute(ttl, concurrent_opts, &block)
      end
    end
  end
end
