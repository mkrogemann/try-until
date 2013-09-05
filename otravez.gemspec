# -*- encoding: utf-8 -*-
require File.expand_path('../lib/otravez/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Markus Krogemann"]
  gem.email         = ["markus@krogemann.de"]
  gem.description   = %q{otravez library supports repeatedly calling code that may fail/timeout. Matchers can be used to specify expected response}
  gem.summary       = %q{Retry and matching logic}
  gem.homepage      = "https://github.com/mkrogemann/otravez"
  gem.license       = 'MIT'

  gem.files         = Dir['lib/**/*.rb']
  gem.test_files    = []
  gem.name          = "otravez"
  gem.require_paths = ["lib"]
  gem.version       = Otravez::VERSION
  gem.add_development_dependency('rspec', '~> 2.14.1')
  gem.add_development_dependency('simplecov', '~> 0.7.1')
end
