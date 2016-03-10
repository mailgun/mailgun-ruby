require 'bundler/gem_tasks'
require 'rake'
require 'rspec/core/rake_task'

desc 'Build Gem'
task :build do
  system 'gem build mailgun.gemspec'
end

desc 'Run unit specs'
RSpec::Core::RakeTask.new('spec:unit') do |t|
  t.rspec_opts = %w(--colour --format documentation)
  t.pattern = 'spec/unit/*_spec.rb', 'spec/unit/*/*_spec.rb'
end

desc 'Run integration specs'
# Before running integration tests, you need to specify
# a valid API KEY in the spec/spec_helper.rb file.
RSpec::Core::RakeTask.new('spec:integration') do |t|
  t.rspec_opts = %w(--colour --format documentation)
  t.pattern = 'spec/integration/*_spec.rb'
end

desc 'Run all tests'
RSpec::Core::RakeTask.new('spec:all') do |t|
  t.rspec_opts = %w(--colour --format documentation)
  t.pattern = 'spec/**/*_spec.rb'
end

task default: 'spec:unit'
task spec: 'spec:unit'

task :console do
  sh 'pry --gem'
end
