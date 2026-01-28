module Mailgun

  # A Mailgun::AnalyticsTags object is a simple CRUD interface to Mailgun Tags.
  # Uses Mailgun
  class AnalyticsTags
    include ApiVersionChecker

    # Public: creates a new Mailgun::AnalyticsTags instance.
    # Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new(Mailgun.api_key, Mailgun.api_host || 'api.mailgun.net', 'v1'))
      @client = client
    end

    def update(tag, description)
      @client.put('analytics/tags', { tag: tag, description: description }.to_json, { "Content-Type" => "application/json" } ).to_h['message'] == 'Tag updated'
    end

    def list(options = {})
      @client.post('analytics/tags', options).to_h['items']
    end

    def remove(tag)
      @client.delete('analytics/tags', { tag: tag }, body_params: true).to_h['message'] == 'Tag deleted'
    end

    def limits
      @client.get('analytics/tags/limits').to_h
    end

    enforces_api_version 'v1', :update, :list, :remove, :limits
  end
end
