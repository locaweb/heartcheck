require 'heartcheck'
require 'pry'

Dir['./spec/support/**/*.rb'].each{ |helper_file| require helper_file }

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
