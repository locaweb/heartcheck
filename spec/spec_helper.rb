require 'heartcheck'
require 'pry'

%w(support/**/*.rb).each { |path| Dir[File.join(File.dirname(__FILE__), path)].each { |f| require f } }

RSpec.configure do |config|
  # config.include JsonSpec::Helpers
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
