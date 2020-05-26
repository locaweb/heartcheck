module Heartcheck
  module Services
    class ResponseFormatter
      attr_reader :hash_formatter

      def initialize(hash_formatter)
        @hash_formatter = hash_formatter
      end

      def execute(checks)
        return checks unless hash_formatter

        checks.map do |check|
          format(check)
        end.reduce({}, :merge)
      end

      private

      def format(check)
        check.tap do |obj|
          value = obj.values.first.merge(Hash[:time => obj[:time]])
          obj.delete(:time)
          obj.merge!(Hash[obj.keys.first => value])
        end
      end 
    end
  end
end
  