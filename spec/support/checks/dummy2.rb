# frozen_string_literal: true

module Heartcheck
  module Checks
    class Dummy2 < Base
      def validate; end

      def info
        'dummy2'
      end
    end
  end
end
