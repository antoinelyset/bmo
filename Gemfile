source 'https://rubygems.org'

# Specify your gem's dependencies in bmo.gemspec
gemspec

group :test do
  gem 'rspec'
  gem 'rubocop'
  gem 'simplecov', require: false
  gem 'coveralls', require: false
end

group :development do
  # Prying
  gem 'jazz_hands'

  # Metrics
  gem 'flay'
  gem 'flog'
  gem 'reek'

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
