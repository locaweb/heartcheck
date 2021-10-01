# frozen_string_literal: true

module Heartcheck
  module Checks
    class Dummy1 < Base
      def validate; end

      def info
        'dummy1'
      end
    end
  end
end
