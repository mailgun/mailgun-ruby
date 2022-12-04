require 'mailgun/exceptions/exceptions'

module Mailgun

  # A Mailgun::Domains object is a simple CRUD interface to Mailgun Domains.
  # Uses Mailgun
  class Domains

    # Public: creates a new Mailgun::Domains instance.
    #   Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new)
      @client = client
    end

    # Public: Get Domains
    #
    # limit - [Integer] Maximum number of records to return. (100 by default)
    # skip  - [Integer] Number of records to skip. (0 by default)
    #
    # Returns [Array] A list of domains (hash)
    def list(options = {})
      @client.get('domains', options).to_h['items']
    end
    alias_method :get_domains, :list

    # Public: Get domain information
    #
    # domain - [String] Domain name to lookup
    #
    # Returns [Hash] Information on the requested domains.
    def info(domain)
      fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
      @client.get("domains/#{domain}").to_h!
    end
    alias_method :get, :info
    alias_method :get_domain, :info

    # Public: Verify domain, update domain records
    #   Unknown status - this is not in the current Mailgun API
    #   Do no rely on this being available in future releases.
    #
    # domain - [String] Domain name
    #
    # Returns [Hash] Information on the updated/verified domains
    def verify(domain)
      fail(ParameterError, 'No domain given to verify on Mailgun', caller) unless domain
      @client.put("domains/#{domain}/verify", nil).to_h!
    end
    alias_method :verify_domain, :verify

    # Public: Add domain
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #     smtp_password - [String] Password for SMTP authentication
    #     spam_action   - [String] disabled or tag
    #       Disable, no spam filtering will occur for inbound messages.
    #       Tag, messages will be tagged wtih a spam header. See Spam Filter.
    #     wildcard      - [Boolean] true or false Determines whether the domain will accept email for sub-domains.
    #
    # Returns [Hash] of created domain
    def create(domain, options = {})
      fail(ParameterError, 'No domain given to add on Mailgun', caller) unless domain
      options = { smtp_password: nil, spam_action: 'disabled', wildcard: false }.merge(options)
      options[:name] = domain
      @client.post('domains', options).to_h
    end
    alias_method :add, :create
    alias_method :add_domain, :create

    # Public: Delete Domain
    #
    # domain - [String] domain name to delete (ex. domain.com)
    #
    # Returns [Boolean] if successful or not
    def remove(domain)
      fail(ParameterError, 'No domain given to remove on Mailgun', caller) unless domain
      @client.delete("domains/#{domain}").to_h['message'] == 'Domain has been deleted'
    end
    alias_method :delete, :remove
    alias_method :delete_domain, :remove

  end
end
