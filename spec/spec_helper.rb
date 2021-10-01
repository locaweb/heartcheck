# frozen_string_literal: true

require 'heartcheck'
require 'pry'
require 'oj'

Dir['./spec/support/**/*.rb'].sort.each { |helper_file| require helper_file }

Oj.default_options = { mode: :compat }

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = :expect
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    # reset variables
    Heartcheck.instance_variable_set(:@checks, [])
    Heartcheck.instance_variable_set(:@logger, nil)

    # silent log
    Heartcheck.logger = Logger.new(nil)
  end
end
