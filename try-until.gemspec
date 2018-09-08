require File.expand_path('../lib/try_until/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Markus Krogemann']
  gem.email         = ['markus@krogemann.de']
  gem.description   = 'The try-until library supports repeatedly calling code that may fail or respond with values other than expected. Matchers, realized as lambdas, can be used to specify expected result.'
  gem.summary       = 'Retry and matching logic'
  gem.homepage      = 'https://github.com/mkrogemann/try-until'
  gem.license       = 'MIT'

  gem.files         = Dir['lib/**/*.rb']
  gem.test_files    = []
  gem.name          = 'try-until'
  gem.require_paths = ['lib']
  gem.version       = TryUntil::VERSION

  gem.add_development_dependency('metric_fu', '~> 4.11.1') unless ENV['TRAVIS'] == 'true'
  gem.add_development_dependency('rspec', '~> 3.1.0')
  gem.add_development_dependency('simplecov', '~> 0.9.1')
end
