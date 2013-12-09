guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard :rubocop do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

guard :flog do
  watch(%r{^lib/(.+)\.rb$})
end

guard :reek do
  watch(%r{^lib/(.+)\.rb$})
end

guard :flay do
  watch(%r{^lib/(.+)\.rb$})
end
