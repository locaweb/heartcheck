module Heartcheck
  require 'logger'
  require 'heartcheck/app'
  require 'heartcheck/checks'
  require 'heartcheck/executors'
  require 'heartcheck/errors'
  require 'heartcheck/services'
  require 'heartcheck/logger'
  require 'active_support/cache'

  @checks = []

  class << self
    # @attr [Array<Checks>] the checks to use when checking
    attr_accessor :checks

    # @attr [Heartcheck::Executors::Base] the checks executor backend
    attr_accessor :executor

    # @attr_writer [Object] change the default logger
    attr_writer :logger

    # @attr_writer [Object] change the default cache
    attr_writer :cache

    # Is used to log some messages when checking if the logger
    # is not set it's returns de default_logger.
    #
    # @return [Object] the logger object
    def logger
      @logger ||= default_logger
    end

    # @abstract
    # Is used to configure.
    #
    # @yield A bock that recieve the class
    #
    # @example
    #   Heartcheck.setup do |c|
    #     puts c
    #   end
    #
    # @return [void]
    def setup
      yield(self)
    end

    # It's used to add an instance of a check
    # to the check list
    #
    # @param [String] name to identify in the result page
    # @param [Hash] options the options to create an instance of a check.
    # @option options [String] :class The class name to get an instance
    # @yield a block to config the instance
    #
    # @example
    #   Heartcheck.add(:base) do |c|
    #     c.name = 'Base check'
    #   end
    #
    # @return [void]
    def add(name, options = {}, &block)
      class_name = options.fetch(:class) { constantize(name) }
      instance = Checks.const_get(class_name).new

      if block_given?
        checks << instance.tap(&block)
      else
        checks << instance
      end
    end

    # filter checks that are essential
    #
    # @return [Array<Check>] checks that are essential
    def essential_checks
      checks.select { |ctx| !ctx.functional? && !ctx.dev? }
    end

    # filter checks that are functional
    #
    # @return [Array<Check>] checks that are functional
    def functional_checks
      checks.select(&:functional?)
    end

    # filter checks that are not functional
    #
    # @return [Array<Check>] checks that are not functional
    def dev_checks
      checks.select { |ctx| !ctx.functional? }
    end

    # filter checks that has some information
    #
    # @return [Array<Check>] checks that respond to :info
    def info_checks
      checks.select { |ctx| ctx.respond_to?(:info) }
    end

    # an executor class that respond to dispatch(checkers)
    #
    # @return [Heartcheck::Executors::Base]
    def executor
      @executor ||= Heartcheck::Executors::Base.new
    end

    # change current executor to a threaded implementation
    # requires 'concurrent-ruby'
    #
    # @return [Heartcheck::Executors::Threaded]
    def use_threaded_executor!
      require "concurrent"
      require "heartcheck/executors/threaded"

      self.executor = Heartcheck::Executors::Threaded.new
    end

    def cache
      @cache ||= ActiveSupport::Cache::MemoryStore.new
    end

    private

    # if no logger is setted we create an instance
    # of ruby logger with STDOUT
    #
    # @return [Logger] a ruby logger to STDOUT and info level
    def default_logger
      log = ::Logger.new(STDOUT)
      log.level = ::Logger::INFO
      log
    end

    # helper method to get a constant
    #
    # @param [String] name of class
    #
    # @example
    #   contantize('my_check') => 'MyCheck'
    #
    # @return [String]
    def constantize(name)
      name.to_s.split('_').map(&:capitalize).join
    end
  end
end
