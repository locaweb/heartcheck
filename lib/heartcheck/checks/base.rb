module Heartcheck
  module Checks
    # Base check that contains the common functionality for chechs
    class Base
      # When it is true the check will work just for `/functional` route.
      #   It should be used to add warning messages that need to verify,
      #   but doesn't break your application.
      #   For example when your async process has more than 3 jobs.
      #
      # @return [Boolean] (default: false)
      attr_accessor :functional
      alias_method :functional?, :functional

      # When it is true the check will work just for `/dev` route.
      #   you can use it to create some check is not essential/functional for you app.
      #   For example you can execute some performance check.
      #
      # @return [Boolean] (default: false)
      attr_accessor :dev
      alias_method :dev?, :dev

      # The name for identify the check in the result page
      #
      # @return [String]
      attr_accessor :name

      # Time that the check has to execute.
      #   If it is 0 the timeout will be disable
      #
      # @return [Integer] (default: 0)
      attr_accessor :timeout

      # An url to provide more info about the check.
      #   It is important to provide details about the failure, for example:
      #   - what is the impact
      #   - how to fix it
      #   - how to reproduce the failure
      # @return [String] (default: nil)
      attr_accessor :doc_url

      # Create a new instance and set the default values.
      #
      # @return [Check]
      def initialize
        @dynamic_services = nil
        @error_proc       = nil
        @errors           = []
        @functional       = false
        @dev              = false
        @name             = self.class.name.split('::').last.downcase
        @services         = []
        @timeout          = 0
        @validate_proc    = nil
      end

      # Seter to add a proc to execute when some check fail.
      #
      # @return [void]
      def on_error(&block)
        @error_proc = block if block_given?
      end

      # Seter to add a proc to execute to check.
      #
      # @yieldparam services [Array<Hash>] services to check
      # @yieldparam errors [Array<String>] to add error message when check fails
      #
      # @example
      #   c.to_validate do |services, errors|
      #     services.each do |service|
      #       errors << "erro message" unless if service[:connection].connected?
      #     end
      #   end
      #
      # @return [void]
      def to_validate(&block)
        @validate_proc = block if block_given?
      end

      # It is used to register dynamic services thats need to be evaluate when the checker is running.
      #  This proc need to return an Array.
      #
      # @example
      #   register_dynamic_services do
      #     [
      #       { name: 'service name', connection: MyConnection }
      #     ]
      #   end
      #
      # @return [void]
      def register_dynamic_services(&block)
        @dynamic_services = block if block_given?
      end

      # It is used to add a service that will use when check run.
      #
      # @param service [Hash]
      #
      # @example
      #   add_service(name: 'service name', connection: MyConnection)
      #
      # @return [void]
      def add_service(service)
        @services << service
      end


      # It is used to add a service that will use when check run.
      #
      # @return [Array<Hash>]
      def services
        if @dynamic_services
          @services + @dynamic_services.call
        else
          @services
        end
      end

      # run the check and return formated erros
      #
      # @return [Hash]
      def check
        validation
        { name => { 'status' => (@errors.empty? ? 'ok' : 'error') } }.tap do |response|
          response[name]['message'] = error_message unless @errors.empty?
        end
      end

      # Returns a human-readable representation of the check
      #
      # @return [String]
      def inspect
        "#<#{self.class.name} name: #{name}, functional: #{functional?}, dev: #{dev?}>"
      end

      # Returns a structure comprised of host, port and
      # schema (protocol) for the check
      #
      # @return [Hash]
      def uri_info
        { error: "#{self.class.name} #url_info not implemented." }
      end

      def informations
        info
      rescue => e
        { 'error' => e.message }
      end

      private

      # Used to add an error to @erros.
      #
      # @return [void]
      def append_error(*args)
        if @error_proc
          @error_proc.call(@errors, *args)
        else
          custom_error(*args)
        end
      end

      # run the check
      #
      # @return [Array<String>]
      def validation
        @errors = []
        begin
          Timeout.timeout(timeout, Heartcheck::Errors::Warning) do
            if @validate_proc
              @validate_proc.call(services, @errors)
            else
              validate
            end
          end
        rescue Heartcheck::Errors::Warning => w
          @errors = [{ type: 'warning', message: w.message }]
        rescue => e
          @errors = [e.message]
        end
        @errors
      end

      # Get formated error messages for each service after run the check
      #
      # @example
      #   @erros = ['some string']
      #   error_message
      #   # => [{type: 'error', message: 'some string'}]
      #
      # @return [Array<Hash>]
      def error_message
        @errors.map(&format_error)
      end

      # format the an error message with a format the check need.
      #
      # @example
      #   "some string".format_error
      #   # => {type: 'error', message: 'some string'}
      #
      # @return [Hash]
      def format_error
        lambda do |error|
          if error.is_a?(Hash)
            error
          else
            { type: 'error', message: error, doc_url: doc_url }
          end
        end
      end
    end
  end
end
