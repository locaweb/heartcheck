# frozen_string_literal: true

module Heartcheck
  module Controllers
    class Info < Base
      def index
        MultiJson.dump(Heartcheck
                .info_checks
                .map(&:informations))
      end
    end
  end
end
