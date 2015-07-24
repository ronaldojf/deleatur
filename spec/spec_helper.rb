require 'codeclimate-test-reporter'
require 'simplecov'

CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random
  config.color = true
  Kernel.srand config.seed
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end
end
