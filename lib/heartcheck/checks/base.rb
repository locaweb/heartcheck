module Heartcheck
  module Checks
    class Base
      attr_accessor :functional, :dev, :name, :timeout

      alias_method :functional?, :functional
      alias_method :dev?, :dev

      # call in Heartcheck.set
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

      def on_error(&block)
        @error_proc = block if block_given?
      end

      def to_validate(&block)
        @validate_proc = block if block_given?
      end

      def register_dynamic_services(&block)
        @dynamic_services = block if block_given?
      end

      def add_service(service)
        @services << service
      end

      def services
        if @dynamic_services
          @services + @dynamic_services.call
        else
          @services
        end
      end

      def check
        validation
        hash = { name => { 'status' => (@errors.empty? ? 'ok' : 'error') } }
        hash[name]['message'] = error_message unless @errors.empty?

        Logger.info Oj.dump(hash)
        hash
      end

      def informations
        info
      rescue => e
        { 'error' => e.message }
      end

      private

      def append_error(*args)
        if @error_proc
          @error_proc.call(@errors, *args)
        else
          custom_error(*args)
        end
      end

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

      def error_message
        @errors.map(&format_error)
      end

      def format_error
        lambda do |error|
          error.is_a?(Hash) ? error : { type: 'error', message: error }
        end
      end

    end
  end
end
