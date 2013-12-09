# -*- encoding: utf-8 -*-
source 'https://rubygems.org'

# Specify your gem's dependencies in poleica.gemspec
gemspec

group :test do
  gem 'rspec'
  gem 'coveralls'
  gem 'flay'
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
  gem 'simplecov'
end

group :development do
  gem 'jazz_hands'

  # Guards
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'guard-flay', github: 'pericles/guard-flay'
  gem 'guard-reek', github: 'pericles/guard-reek'
  gem 'guard-flog', github: 'antoinelyset/guard-flog'
end

group :darwin do
  gem 'terminal-notifier-guard'
end
