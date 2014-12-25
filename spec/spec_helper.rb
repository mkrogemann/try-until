if ENV['COVERAGE'] == 'true'
  require 'simplecov'
end

if ENV['TRAVIS'] == 'true'
  require 'coveralls'
  Coveralls.wear!
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

require 'try_until'