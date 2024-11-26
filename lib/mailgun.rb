require 'tempfile'
require 'rest_client'
require 'yaml'
require 'json'

require 'mailgun/version'
require 'mailgun/client'
require 'mailgun/response'
require 'mailgun/chains'
require 'mailgun/address'
require 'mailgun/lists/opt_in_handler'
require 'mailgun/messages/batch_message'
require 'mailgun/messages/message_builder'
require 'mailgun/events/events'
require 'mailgun/exceptions/exceptions'
require 'mailgun/domains/domains'
require 'mailgun/webhooks/webhooks'
require 'mailgun/templates/templates'
require 'mailgun/subaccounts/subaccounts'
require 'mailgun/tags/tags'
require 'mailgun/metrics/metrics'

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
