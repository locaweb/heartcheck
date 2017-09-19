require 'sys-uname'

module Heartcheck
  module Controllers
    class Environment < Base
      def index
        MultiJson.dump(
          {
            'system-info' => Sys::Uname.uname,
            'ruby-version' => RUBY_VERSION,
            'rails-version' => defined?(Rails) ? Rails::VERSION::STRING : '(none)'
          }
        )
      end
    end
  end
end
