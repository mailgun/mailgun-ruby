$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler.setup(:development)
require 'mailgun'
require_relative 'unit/connection/test_client'

# INSERT YOUR API KEYS HERE
APIKEY = "key"
PUB_APIKEY = "pubkey"
APIHOST = "api.mailgun.net"
APIVERSION = "v2"
SSL= true
