require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler.setup(:development)

require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'mailgun'

require 'vcr'
require 'webmock/rspec'

#WebMock.disable_net_connect!(allow_localhost: true)
require_relative 'unit/connection/test_client'

RSpec.configure do |c|
  c.raise_errors_for_deprecations!
end

APIHOST = "api.mailgun.net"
APIVERSION = "v3"
SSL = true

# For integration tests modify .ruby-env.yml
# use .ruby-env.yml.example for an example
# alternatively
# set environment variables as named in .ruby-env.yml.example
envfile = File.join(File.dirname(__FILE__), '..','.ruby-env.yml')
envs = File.exist?(envfile) ? YAML.load_file(envfile) : ENV
APIKEY = envs['MAILGUN_APIKEY']
PUB_APIKEY = envs['MAILGUN_PUB_APIKEY']
TESTDOMAIN = envs['MAILGUN_TESTDOMAIN']

VCR.configure do |c|
  c.cassette_library_dir = 'vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
  c.filter_sensitive_data('<APIKEY>') { APIKEY }
  c.filter_sensitive_data('DOMAIN.TEST') { TESTDOMAIN }
  c.filter_sensitive_data('<PUBKEY>') { PUB_APIKEY }
end
