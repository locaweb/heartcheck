module Heartcheck
  module Controllers
    class Functional < Base
      def index
        check(:functional)
      end
    end
  end
end
