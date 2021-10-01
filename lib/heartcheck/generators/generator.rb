# frozen_string_literal: true

require 'thor/group'

module Heartcheck
  class Generator < Thor::Group
    include Thor::Actions

    desc 'generate default files and instructions to use the Heartcheck'

    argument :framework

    def self.source_root
      File.join(File.dirname(__FILE__), 'templates')
    end

    def show_framework
      box framework.capitalize, :green
    end

    def generate_initializer
      template('config.rb', initializer_path)
    end

    def generate_route
      case framework
      when 'rails'
        instructions(
          'config/routes.rb',
          [
            'mount Heartcheck::App.new, at: "/monitoring"',
            '',
            '# to mount a caching instance:',
            '# mount Heartcheck::CachingApp.new(Heartcheck::App.new, 300),',
            '#   at: "/cached-monitoring" # 300 is the optional cache TTL'
          ].join("\n")
        )
      when 'padrino', 'sinatra'
        instructions(
          'config.ru', [
            'require "heartcheck"',
            '',
            'map "/monitoring" do',
            '  use Heartcheck::App',
            'end',
            '',
            '# or a cached instance:',
            '# map "/cached/monitoring" do',
            '#   use Heartcheck::CachingApp, 300 # 300 is the optional ttl',
            '#   use Heartcheck::App',
            '# end'
          ].join("\n")
        )
      end
    end

    def include_empty_lines
      puts "\n\n"
    end

    private

    def instructions(file_name, file_content)
      box "Include the following content to file #{file_name}"
      say file_content, :blue
    end

    def box(content, color = :red)
      size = content.size
      say "#{'=' * (size + 2)}\n #{content}\n#{'=' * (size + 2)}\n", color
    end

    def initializer_path
      case framework
      when 'rails'              then 'config/initializers/heartcheck.rb'
      when 'padrino', 'sinatra' then 'app/app.rb'
      end
    end
  end
end
