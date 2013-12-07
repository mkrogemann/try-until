# -*- encoding: utf-8 -*-
require File.expand_path('../lib/try_until/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Markus Krogemann"]
  gem.email         = ["markus@krogemann.de"]
  gem.description   = %q{The try-until library supports repeatedly calling code that may fail or respond with values other than expected. Matchers, realized as lambdas, can be used to specify expected result.}
  gem.summary       = %q{Retry and matching logic}
  gem.homepage      = "https://github.com/mkrogemann/try-until"
  gem.license       = 'MIT'

  gem.files         = Dir['lib/**/*.rb']
  gem.test_files    = []
  gem.name          = "try-until"
  gem.require_paths = ["lib"]
  gem.version       = TryUntil::VERSION

  if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
    gem.add_runtime_dependency('rubysl', '~> 2.0')
    gem.add_runtime_dependency('rubysl-json', '~> 2.0.2')
    gem.add_runtime_dependency('rubinius-coverage', '~> 2.0.3')
  end
  gem.add_development_dependency('rspec', '~> 2.14.1')
  gem.add_development_dependency('simplecov', '~> 0.8.2')
  gem.add_development_dependency('metric_fu', '~> 4.4.1') unless ENV['TRAVIS'] == 'true'
end
