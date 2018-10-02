module Mailgun

  # A Mailgun::Webhooks object is a simple CRUD interface to Mailgun Webhooks.
  # Uses Mailgun
  class Webhooks

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
    alias_method :get_webhooks, :list

    # Public: Get webook information for a specific action
    #
    # domain - a String of Domain name to find a webhook url for
    # action - a String identifying the webhook to get the URL for
    #
    # Returns a String of the url for the identified webhook or an
    #   empty String if one is not set
    def info(domain, action)
      res = @client.get("domains/#{domain}/webhooks/#{action}")
      res.to_h['webhook']['url'] || ''
    rescue NoMethodError
      ''
    end
    alias_method :get_webhook_url, :info

    # Public: Add webhook
    #
    # domain - A String of the domain name (ex. domain.com)
    # action - A String of the action to create a webhook for
    # url    - A String of the url of the webhook
    #
    # Returns a Boolean of whether the webhook was created
    def create(domain, action, url = '')
      res = @client.post("domains/#{domain}/webhooks", id: action, url: url)
      res.to_h['webhook']['url'] == url && res.to_h['message'] == 'Webhook has been created'
    end
    alias_method :add, :create
    alias_method :add_webhook, :create

    # Public: Sets all webhooks to the same URL
    #
    # domain - A String of the domain name
    # url    - A String of the url to set all webhooks to
    #
    # Returns true or false
    def create_all(domain, url = '')
      %w(bounce click deliver drop open spam unsubscribe).each do |action|
        add_webhook domain, action, url
      end
      true
    rescue
      false
    end
    alias_method :add_all_webhooks, :create_all

    # Public: Delete a specific webhook
    #
    # domain - The required String of domain name
    # action - The required String of the webhook action to delete
    #
    # Returns a Boolean of the success
    def remove(domain, action)
      fail Mailgun::ParameterError('Domain not provided to remove webhook from') unless domain
      fail Mailgun::ParameterError('Action not provided to identify webhook to remove') unless action
      @client.delete("domains/#{domain}/webhooks/#{action}").to_h['message'] == 'Webhook has been deleted'
    rescue Mailgun::CommunicationError
      false
    end
    alias_method :delete, :remove
    alias_method :delete_webhook, :remove

    # Public: Delete all webhooks for a domain
    #
    # domain - A required String of the domain to remove all webhooks for
    #
    # Returns a Boolean on the success
    def remove_all(domain)
      fail Mailgun::ParameterError('Domain not provided to remove webhooks from') unless domain
      %w(bounce click deliver drop open spam unsubscribe).each do |action|
        delete_webhook domain, action
      end
    end
    alias_method :delete_all, :remove_all
    alias_method :delete_all_webooks, :remove_all

  end
end
