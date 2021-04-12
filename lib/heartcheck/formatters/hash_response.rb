module Heartcheck
  module Formatters
    class HashResponse
      def format(checks)
        checks.each_with_object({}) do |check, response|
          name = check.keys.first
          result = check.delete(name)

          response[name] = result.merge(check)
        end
      end
    end
  end
end
