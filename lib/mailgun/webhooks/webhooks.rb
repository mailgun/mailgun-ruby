# frozen_string_literal: true

module Mailgun
  # A Mailgun::Webhooks object is a simple CRUD interface to Mailgun Webhooks.
  # Uses Mailgun
  class Webhooks
    include ApiVersionChecker

    ACTIONS = %w[accepted clicked complained delivered opened permanent_fail temporary_fail unsubscribed].freeze

    # Public creates a new Mailgun::Webhooks instance.
    #   Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new)
      @client = client
    end

    # Public: Get Webhooks
    #
    # domain  - a string the domain name to retrieve webhooks for
    # options - a Hash of options
    #
    # Returns a Hash of the list of domains or nil
    def list(domain, options = {})
      res = @client.get("domains/#{domain}/webhooks", options)
      res.to_h['webhooks']
    end

    # :nocov:

    def get_webhooks(domain, _options = {})
      warn('`get_webhooks` method will be deprecated in future versions of Mailgun. Please use `list` instead.')
      list(domain, {})
    end
    # :nocov:

    # Public: Get webook information for a specific action
    #
    # domain - a String of Domain name to find a webhook url for
    # action - a String identifying the webhook to get the URL for
    #
    # Returns a String of the url for the identified webhook or an
    #   empty String if one is not set
    def get(domain, action)
      res = @client.get("domains/#{domain}/webhooks/#{action}")
      res.to_h['webhook']['urls'] || ''
    end

    # :nocov:
    %i[info get_webhook_url].each do |method|
      define_method(method) do |domain, action|
        warn("`#{method}` method will be deprecated in future versions of Mailgun. Please use `get` instead.")
        get(domain, action)
      end
    end
    # :nocov:

    # Public: Add webhook
    #
    # domain - A String of the domain name (ex. domain.com)
    # action - A String of the action to create a webhook for
    # url    - A String of the url of the webhook
    #
    # Returns a Boolean of whether the webhook was created
    def create(domain, action, url = '')
      res = @client.post("domains/#{domain}/webhooks", id: action, url: url)
      res.to_h['webhook']['urls'].include?(url) && res.to_h['message'] == 'Webhook has been created'
    end

    # :nocov:
    %i[add add_webhook].each do |method|
      define_method(method) do |domain, action, url|
        url ||= ''
        warn("`#{method}` method will be deprecated in future versions of Mailgun. Please use `create` instead.")
        create(domain, action, url)
      end
    end
    # :nocov:

    # Public: Sets all webhooks to the same URL
    #
    # domain - A String of the domain name
    # url    - A String of the url to set all webhooks to
    #
    # Returns true or false
    # :nocov:
    %i[create_all add_all_webhooks].each do |method|
      define_method(method) do |domain|
        warn("`#{method}` method will be deprecated in future versions of Mailgun. Please use `create` instead.")

        ACTIONS.each do |action|
          create domain, action, url
        end
      end
    end
    # :nocov:

    # Public: Update webhook
    #
    # domain - A String of the domain name (ex. domain.com)
    # action - A String of the action to create a webhook for
    # url    - A String of the url of the webhook
    #
    # Returns a Boolean of whether the webhook was updated
    def update(domain, action, url = '')
      raise Mailgun::ParameterError('Domain not provided to update webhooks') unless domain
      raise Mailgun::ParameterError('Action not provided to identify webhook to update') unless action

      res = @client.put("domains/#{domain}/webhooks/#{action}", id: action, url: url)
      res.to_h['message'] == 'Webhook has been updated'
    end

    # :nocov:
    def update_webhook(domain, action, url = '')
      warn('`update_webhook` method will be deprecated in future versions of Mailgun. Please use `update` instead.')
      update(domain, action, url)
    end
    # :nocov:

    # Public: Delete a specific webhook
    #
    # domain - The required String of domain name
    # action - The required String of the webhook action to delete
    #
    # Returns a Boolean of the success
    def remove(domain, action)
      raise Mailgun::ParameterError('Domain not provided to remove webhook from') unless domain
      raise Mailgun::ParameterError('Action not provided to identify webhook to remove') unless action

      @client.delete("domains/#{domain}/webhooks/#{action}").to_h['message'] == 'Webhook has been deleted'
    end

    # :nocov:
    %i[delete delete_webhook].each do |method|
      define_method(method) do |domain, action|
        warn("`#{method}` method will be deprecated in future versions of Mailgun. Please use `remove` instead.")
        remove(domain, action)
      end
    end
    # :nocov:

    # Public: Delete all webhooks for a domain
    #
    # domain - A required String of the domain to remove all webhooks for
    #
    # Returns a Boolean on the success
    # :nocov:
    %i[remove_all delete_all delete_all_webooks].each do |method|
      define_method(method) do |domain|
        warn("`#{method}` method will be deprecated in future versions of Mailgun. Please use `remove` instead.")

        raise Mailgun::ParameterError('Domain not provided to remove webhooks from') unless domain

        ACTIONS.each do |action|
          remove domain, action
        end
      end
    end
    # :nocov:

    enforces_api_version 'v3', :list, :get, :create, :update, :remove
  end
end
