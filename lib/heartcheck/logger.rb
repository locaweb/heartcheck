module Heartcheck
  # A simple Interface to log messages
  class Logger
    # log message with debug level
    #
    # @param message [String] message to log
    #
    # @return [void]
    def self.debug(message)
      logger(:debug, message)
    end

    # log message with info level
    #
    # @param message [String] message to log
    #
    # @return [void]
    def self.info(message)
      logger(:info, message)
    end

    # log message with warn level
    #
    # @param message [String] message to log
    #
    # @return [void]
    def self.warn(message)
      logger(:warn, message)
    end

    # log message with error level
    #
    # @param message [String] message to log
    #
    # @return [void]
    def self.error(message)
      logger(:error, message)
    end

    private

    # Sent the message to Heartcheck logger
    # that you can configure
    #
    # @see Heartcheck.logger
    # @param level [Symbol] the level log
    # @param message [String] message to log
    #
    # @return [void]
    def self.logger(level, message)
      Heartcheck.logger.send(level, "[Heartcheck] #{message}")
    end
  end
end
