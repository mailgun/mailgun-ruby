# frozen_string_literal: true

module Mailgun
  # A Mailgun::AccountWebhooks object is a simple CRUD interface to Account Mailgun Webhooks.
  # Uses Mailgun
  class AccountWebhooks
    include ApiVersionChecker

    # Public creates a new Mailgun::Webhooks instance.
    #   Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new(Mailgun.api_key, Mailgun.api_host || 'api.mailgun.net', 'v1'))
      @client = client
    end

    # Public: List account-level webhooks
    #
    # webhook_ids - [String] Comma-separated list of webhook IDs to filter results. If specified,
    #               only webhooks with matching IDs will be returned.
    #
    # Retrieve all account-level webhooks or filter by specific webhook IDs.
    # Returns webhook details including associated event types.
    def list(webhook_ids = '')
      res = @client.get('webhooks', webhook_ids: webhook_ids)
      res.to_h['webhooks']
    end

    # Public: Create an account-level webhook
    #
    # description - [String] Description for the webhook
    # event_types - [String] Event types to subscribe to. Use multiple times to specify multiple event types.
    #               Maximum of 3 unique URLs per event type.
    # url         - [String] URL for webhook to be sent to
    #
    # Returns the Unique identifier for the webhook
    def create(description:, event_types:, url:)
      res = @client.post('webhooks', { description: description, event_types: event_types, url: url })
      res.to_h
    end

    # Public: Delete account-level webhooks
    #
    # webhook_ids - [String] Comma-separated list of webhook IDs to delete.
    #               If provided, only these specific webhooks will be deleted.
    # all         - [Boolean] The required String of the webhook action to delete
    #
    # Returns a Boolean of the success
    def remove(webhook_ids = nil, all: false)
      @client.delete('webhooks', { webhook_ids: webhook_ids, all: all }.compact).status == 204
    end

    # Public: Get account-level webhook by ID
    #
    # webhook_id - [String] The webhook ID to retrieve
    #
    # Returns webhook details including associated event types.
    def get(webhook_id)
      res = @client.get("webhooks/#{webhook_id}")
      res.to_h
    end

    # Public: Update an account-level webhook
    #
    # description - [String] Description for the webhook
    # event_types - [String] Event types to subscribe to. Use multiple times to specify multiple event types.
    #               Maximum of 3 unique URLs per event type.
    # url         - [String] URL for webhook to be sent to
    #
    # Returns a Boolean of the success
    def update(webhook_id, description:, event_types:, url:)
      @client.put("webhooks/#{webhook_id}",
                  { description: description, event_types: event_types, url: url }).status == 204
    end

    # Public: Delete account-level webhook by ID
    #
    # webhook_id - [String] The webhook ID to delete
    #
    # Returns a Boolean of the success
    def remove_by_id(webhook_id)
      @client.delete("webhooks/#{webhook_id}").status == 204
    end

    enforces_api_version 'v1', :list, :create, :remove, :get, :update, :remove_by_id
  end
end
