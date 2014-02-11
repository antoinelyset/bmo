# encoding: utf-8

require File.expand_path('../lib/bmo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'bmo'
  gem.summary       = 'Push notifications to iOS and Android devices'
  gem.description   = gem.summary
  gem.authors       = ['Antoine Lyset']
  gem.email         = ['antoinelyset@gmail.com']
  gem.homepage      = 'https://github.com/antoinelyset/bmo'
  gem.require_paths = ['lib']
  gem.version       = BMO::VERSION.dup
  gem.files           = `git ls-files`.split("\n")
  gem.test_files      = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables     = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  gem.add_runtime_dependency 'equalizer', '~> 0.0.0'
  gem.add_runtime_dependency 'faraday', '~> 0.9.0'

  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'rake'

  gem.license       = 'MIT'
end
