require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :rubocop do |t|
  sh 'rubocop'
end

task :default => [:spec, :rubocop]
