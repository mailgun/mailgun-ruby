# require ruby dependencies
require 'json'
require 'openssl'
require 'tempfile'
require 'time'
require 'uri'
require 'yaml'

# require external dependencies
require 'faraday'
require 'faraday/multipart'
require 'mini_mime'
require 'zeitwerk'

require 'mailgun/exceptions/exceptions'
require 'mailgun/helpers/api_version_checker'

# load zeitwerk
Zeitwerk::Loader.for_gem.tap do |loader| # rubocop:disable Style/SymbolProc
  loader.ignore("#{__dir__}/mailgun-ruby.rb")
  loader.ignore("#{__dir__}/railgun.rb")
  loader.ignore("#{__dir__}/railgun")

  loader.collapse("#{__dir__}/mailgun/domains")
  loader.collapse("#{__dir__}/mailgun/events")
  loader.collapse("#{__dir__}/mailgun/exceptions")
  loader.collapse("#{__dir__}/mailgun/helpers")
  loader.collapse("#{__dir__}/mailgun/lists")
  loader.collapse("#{__dir__}/mailgun/logs")
  loader.collapse("#{__dir__}/mailgun/messages")
  loader.collapse("#{__dir__}/mailgun/metrics")
  loader.collapse("#{__dir__}/mailgun/subaccounts")
  loader.collapse("#{__dir__}/mailgun/tags")
  loader.collapse("#{__dir__}/mailgun/templates")
  loader.collapse("#{__dir__}/mailgun/webhooks")
  loader.setup
end

# Module for interacting with the sweet Mailgun API.
#
# See the Github documentation for full examples.
module Mailgun

  class << self
    attr_accessor :api_host,
                  :api_key,
                  :api_version,
                  :protocol,
                  :mailgun_host,
                  :proxy_url,
                  :test_mode,
                  :domain

    def configure
      yield self
      true
    end
    alias_method :config, :configure
  end

end
