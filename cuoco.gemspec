# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cuoco/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Leonid Shevtsov"]
  gem.email         = ["leonid@shevtsov.me"]
  gem.description   = %q{Run Chef Solo from Capistrano}
  gem.summary       = %q{Use Capistrano for server provisioning and configuration management, not only application deployment.}
  gem.homepage      = "https://github.com/leonid-shevtsov/Cuoco"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cuoco"
  gem.require_paths = ["lib"]
  gem.version       = Cuoco::VERSION

  gem.add_runtime_dependency 'capistrano', '>= 2'
  gem.add_runtime_dependency 'json'

  gem.add_development_dependency 'rake'
end
