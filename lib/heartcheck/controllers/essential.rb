module Heartcheck
  module Controllers
    class Essential < Base
      def index
        check(:essential)
      end
    end
  end
end
