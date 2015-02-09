module Heartcheck
  module Controllers
    class Info < Base
      def index
        Oj.dump(Heartcheck
                .info_checks
                .map(&:informations))
      end
    end
  end
end
