# -*- encoding: utf-8 -*-
require File.expand_path('../lib/try_until/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Markus Krogemann"]
  gem.email         = ["markus@krogemann.de"]
  gem.description   = %q{The try-until library supports repeatedly calling code that may fail/timeout. Matchers can be used to specify expected result}
  gem.summary       = %q{Retry and matching logic}
  gem.homepage      = "https://github.com/mkrogemann/try-until"
  gem.license       = 'MIT'

  gem.files         = Dir['lib/**/*.rb']
  gem.test_files    = []
  gem.name          = "try-until"
  gem.require_paths = ["lib"]
  gem.version       = TryUntil::VERSION
  gem.add_development_dependency('rspec', '~> 2.14.1')
  gem.add_development_dependency('simplecov', '~> 0.7.1')
end
