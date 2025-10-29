require 'mailgun/exceptions/exceptions'

module Mailgun

  # A Mailgun::AnalyticsTags object is a simple CRUD interface to Mailgun Tags.
  # Uses Mailgun
  class AnalyticsTags

    # Public: creates a new Mailgun::AnalyticsTags instance.
    # Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new(Mailgun.api_key, Mailgun.api_host || 'api.mailgun.net', 'v1'))
      @client = client
    end

    def update(tag, description)
      @client.put('analytics/tags', { tag: tag, description: description } ).to_h!
    end

    def list(options = {})
      @client.post('analytics/tags', options).to_h!
    end

    def remove(tag)
      @client.delete('analytics/tags', { tag: tag }).to_h!
    end

    def limits
      @client.get('analytics/tags/limits')
    end
  end
end
