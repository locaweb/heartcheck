require 'sys-uname'

module Heartcheck
  module Controllers
    class Environment < Base
      def index
        MultiJson.dump(
          {
            :system_info => Hash[Sys::Uname.uname.each_pair.to_a],
            :ruby_version => RUBY_VERSION,
            :rails_version => defined?(Rails) ? Rails::VERSION::STRING : '(none)'
          }
        )
      end
    end
  end
end
