# frozen_string_literal: true

module Mailgun
  # A Mailgun::Domains object is a simple CRUD interface to Mailgun DomainsKeys.
  # Uses Mailgun
  class DomainKeys
    include ApiVersionChecker

    def initialize(client = Mailgun::Client.new)
      @client = client
    end

    # Public: List keys for all domains
    #
    # options - [Hash] of
    #   page - [String] Encoded paging information, provided via 'next', 'previous' links
    #   limit - [Integer] Limits the number of items returned in a request
    #   signing_domain  - [String] Filter by signing domain
    #   selector - [String] Filter by selector
    #
    # Returns [Hash] with message key
    def list_domain_keys(options = {})
      @client.get('dkim/keys', options).to_h
    end

    # Public: Create a domain key
    #
    # options - [Hash] of
    #   signing_domain  - [String] Name of the domain (ex. domain.com)
    #   selector - [String] Selector to be used for the new domain key
    #   bits - [Integer] Key size, can be 1024 or 2048
    #   pem - [String] Private key PEM
    #
    # Returns [Hash] with message key
    def create_domain_key(options = {})
      @client.post('dkim/keys', options).to_h
    end

    # Public: Delete a domain key.
    #
    # options - [Hash] of
    #   signing_domain - [Integer] Name of the domain (ex. domain.com)
    #   selector - [String] Name of the selector
    #
    # Returns [Hash] with message key
    def delete_domain_key(options = {})
      @client.delete('dkim/keys', options).to_h
    end

    # Public: Activate a domain key for a specified authority and selector.
    #
    # domain    - [String] Name of the domain (ex. domain.com)
    # selector  - [String] The selector you want to activate for the domain key
    #
    # Returns [Hash] with message key and autority + selector data
    def activate_domain_key(domain, selector)
      @client.put("domains/#{domain}/keys/#{selector}/activate", {}).to_h
    end

    # Public: Lists the domain keys for a specified signing domain / authority
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    #
    # Returns [Hash] with domain keys data
    def get_domain_keys(domain)
      @client.get("domains/#{domain}/keys").to_h
    end

    # Public: Deactivate a domain key for a specified authority and selector
    #
    # domain    - [String] Name of the domain (ex. domain.com)
    # selector  - [String] The selector you want to activate for the domain key
    #
    # Returns [Hash] with message key and autority + selector data
    def deactivate_domain_key(domain, selector)
      @client.put("domains/#{domain}/keys/#{selector}/deactivate", {}).to_h
    end

    # Public: Change the DKIM authority for a domain.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   self  - [Boolean] true - the domain will be the DKIM authority for itself even
    #           if the root domain is registered on the same mailgun account
    #
    # Returns [Hash] Information on the DKIM authority
    def update_domain_dkim_authority(domain, options = {})
      @client.put("domains/#{domain}/dkim_authority", options).to_h
    end

    # Public: Update the DKIM selector for a domains
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   dkim_selector  - [String] change the DKIM selector for a domain.
    #
    # Returns [Hash] with message key
    def update_domain_dkim_selector(domain, options = {})
      @client.put("domains/#{domain}/dkim_selector", options).to_h
    end

    enforces_api_version 'v1', :list_domain_keys, :create_domain_key, :delete_domain_key
    enforces_api_version 'v3', :update_domain_dkim_authority, :update_domain_dkim_selector
    enforces_api_version 'v4', :activate_domain_key, :deactivate_domain_key
    enforces_api_version 'v4', :get_domain_keys
  end
end
