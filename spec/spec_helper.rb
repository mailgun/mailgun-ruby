$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler.setup(:development)
require 'mailgun'
require_relative 'unit/connection/test_client'

# Call tests like this:
# MAILGUN_API_KEY=abcd MAILGUN_PUBLIC_KEY=1234 bundle exec rspec
APIKEY = ENV['MAILGUN_API_KEY']
PUB_APIKEY = ENV['MAILGUN_PUBLIC_KEY']
APIHOST = "api.mailgun.net"
APIVERSION = "v2"
SSL = true
