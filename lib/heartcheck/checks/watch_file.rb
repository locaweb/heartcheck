# frozen_string_literal: true

require 'json'

module Heartcheck
  module Checks
    class WatchFile < Base
      def add_service(options)
        services << options.merge(runtime: installed(options[:file]))
      end

      def validate
        services.each do |service|
          unless service[:runtime].eql? installed(service[:file])
            @errors << 'App outdated, check /monitoring/info for more details!'
          end
        end
      end

      def info
        services.collect do |service|
          { runtime: service[:runtime], installed: installed(service[:file]) }
        end
      end

      private

      def installed(file)
        JSON.parse open(file).read
      end
    end
  end
end
