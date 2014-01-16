begin
	require 'bundler/gem_tasks'
rescue LoadError
end

require 'rake'
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

desc "Build Gem"
	task :default do
		system "gem build mailgun.gemspec"
	end

desc "Run default unit specs"
RSpec::Core::RakeTask.new('spec') do |t|
  t.rspec_opts = %w{--colour --format progress}
  t.pattern = 'spec/unit/*_spec.rb', 'spec/unit/*/*_spec.rb'
end

desc "Run unit specs"
RSpec::Core::RakeTask.new('spec:unit') do |t|
  t.rspec_opts = %w{--colour --format progress}
  t.pattern = 'spec/unit/*_spec.rb', 'spec/unit/*/*_spec.rb'
end

desc "Run integration specs"
# Before running integration tests, you need to specify
# a valid API KEY in the spec/spec_helper.rb file.
RSpec::Core::RakeTask.new('spec:integration') do |t|
  t.rspec_opts = %w{--colour --format progress}
  t.pattern = 'spec/integration/*_spec.rb'
end