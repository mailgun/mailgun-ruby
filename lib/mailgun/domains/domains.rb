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
    #     spam_action   - [String] disabled, blocked or tag
    #       Disable, no spam filtering will occur for inbound messages.
    #       Block, inbound spam messages will not be delivered.
    #       Tag, messages will be tagged with a spam header. See Spam Filter.
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

    # Public: Update domain
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #     spam_action   - [String] disabled, blocked or tag
    #       Disable, no spam filtering will occur for inbound messages.
    #       Block, inbound spam messages will not be delivered.
    #       Tag, messages will be tagged wtih a spam header. See Spam Filter.
    #     web_scheme    - [String] http or https
    #       Set your open, click and unsubscribe URLs to use http or https
    #     wildcard      - [Boolean] true or false Determines whether the domain will accept email for sub-domains.
    #
    # Returns [Hash] of updated domain
    def update(domain, options = {})
      fail(ParameterError, 'No domain given to update on Mailgun', caller) unless domain
      @client.put("domains/#{domain}", options).to_h
    end

    # Public: Creates a new set of SMTP credentials for the defined domain.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   login  - [String] The user name (ex. bob.bar)
    #   password  - [String] A password for the SMTP credentials. (Length Min 5, Max 32)
    #
    # Returns [Hash] with message key
    def create_smtp_credentials(domain, options = {})
      fail(ParameterError, 'No domain given to create credentials on Mailgun', caller) unless domain
      @client.post("domains/#{domain}/credentials", options).to_h
    end

    # Public: Updates the specified SMTP credentials.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # login  - [String] The user name (ex. bob.bar)
    # options - [Hash] of
    #   password  - [String] A password for the SMTP credentials. (Length Min 5, Max 32)
    #
    # Returns [Hash] with message key
    def update_smtp_credentials(domain, login, options = {})
      fail(ParameterError, 'No domain given to update credentials on Mailgun', caller) unless domain
      fail(ParameterError, 'No login given to update credentials on Mailgun', caller) unless login
      @client.put("domains/#{domain}/credentials/#{login}", options).to_h
    end

    # Public: Deletes the defined SMTP credentials.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # login  - [String] The user name (ex. bob.bar)
    #
    # Returns [Hash] with message and spec keys
    def delete_smtp_credentials(domain, login)
      fail(ParameterError, 'No domain given to delete credentials on Mailgun', caller) unless domain
      fail(ParameterError, 'No login given to delete credentials on Mailgun', caller) unless login
      @client.delete("domains/#{domain}/credentials/#{login}").to_h
    end

    # Public: Returns delivery connection settings for the defined domain.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    #
    # Returns [Hash] Information on the delivery connection settings
    def get_domain_connection_settings(domain)
      fail(ParameterError, 'No domain given to retrieve connections on Mailgun', caller) unless domain
      @client.get("domains/#{domain}/connection").to_h
    end

    # Public: Updates the specified delivery connection settings for the defined domain.d
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   require_tls  - [Boolean] true or false. If true - requires the message only be sent over a TLS connection
    #   skip_verification  - [Boolean] true or false. If true - the certificate and hostname will not be verified
    #     when trying to establish a TLS connection
    #
    # Returns [Hash] Information on the delivery connection settings
    def update_domain_connection_settings(domain, options = {})
      fail(ParameterError, 'No domain given to update connections on Mailgun', caller) unless domain
      @client.put("domains/#{domain}/connection", options).to_h
    end

    # Public: Returns tracking settings for the defined domain.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    #
    # Returns [Hash] Information on the tracking settings
    def get_domain_tracking_settings(domain)
      fail(ParameterError, 'No domain given to retrieve tracking settings on Mailgun', caller) unless domain
      @client.get("domains/#{domain}/tracking").to_h
    end

    # Public: Updates the open tracking settings for a domain.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   active  - [Boolean] yes or no. If set to yes, a tracking pixel will be inserted below your HTML content.
    #   place_at_the_top  - [Boolean] yes or no. If set to yes, tracking pixel will be moved to top of your HTML content.
    #
    # Returns [Hash] Information on the tracking open settings
    def update_domain_tracking_open_settings(domain, options = {})
      fail(ParameterError, 'No domain given to update tracking settings on Mailgun', caller) unless domain
      @client.put("domains/#{domain}/tracking/open", options).to_h
    end

    # Public: Updates the click tracking settings for a domain.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   active  - [Boolean] yes or no. If set to yes, links will be overwritten and pointed to our servers so we can track clicks.
    #
    # Returns [Hash] Information on the tracking click settings
    def update_domain_tracking_click_settings(domain, options = {})
      fail(ParameterError, 'No domain given to update tracking settings on Mailgun', caller) unless domain
      @client.put("domains/#{domain}/tracking/click", options).to_h
    end

    # Public: Updates unsubscribe tracking settings for a domain.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   active  - [Boolean] true or false.
    #   html_footer  - [String] Custom HTML version of unsubscribe footer.
    #   text_footer  - [String] Custom text version of unsubscribe footer.
    #
    # Returns [Hash] Information on the tracking unsubscribe settings
    def update_domain_tracking_unsubscribe_settings(domain, options = {})
      fail(ParameterError, 'No domain given to update tracking settings on Mailgun', caller) unless domain
      @client.put("domains/#{domain}/tracking/unsubscribe", options).to_h
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
      fail(ParameterError, 'No domain given to update tracking settings on Mailgun', caller) unless domain
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
      fail(ParameterError, 'No domain given to update tracking settings on Mailgun', caller) unless domain
      @client.put("domains/#{domain}/dkim_selector", options).to_h
    end

    # Public: Update the CNAME used for tracking opens and clicks
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   web_prefix  - [String] change the tracking CNAME for a domain.
    #
    # Returns [Hash] with message key
    def update_domain_web_prefix(domain, options = {})
      fail(ParameterError, 'No domain given to update tracking settings on Mailgun', caller) unless domain
      @client.put("domains/#{domain}/web_prefix", options).to_h
    end

    # Public: Lists the domain keys for a specified signing domain / authority
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    #
    # Returns [Hash] with domain keys data
    def get_domain_keys(domain)
      fail(ParameterError, 'Client api version must be v4', caller) unless @client.api_version == 'v4'
      fail(ParameterError, 'No domain given to retrieve keys on Mailgun', caller) unless domain
      @client.get("domains/#{domain}/keys").to_h
    end

    # Public: Activate a domain key for a specified authority and selector.
    #
    # domain    - [String] Name of the domain (ex. domain.com)
    # selector  - [String] The selector you want to activate for the domain key
    #
    # Returns [Hash] with message key and autority + selector data
    def activate_domain_key(domain, selector)
      fail(ParameterError, 'Client api version must be v4', caller) unless @client.api_version == 'v4'
      fail(ParameterError, 'No domain given to update tracking settings on Mailgun', caller) unless domain
      fail(ParameterError, 'No selector given to activate key on Mailgun', caller) unless selector
      @client.put("domains/#{domain}/keys/#{selector}/activate", {}).to_h
    end

    # Public: Deactivate a domain key for a specified authority and selector
    #
    # domain    - [String] Name of the domain (ex. domain.com)
    # selector  - [String] The selector you want to activate for the domain key
    #
    # Returns [Hash] with message key and autority + selector data
    def deactivate_domain_key(domain, selector)
      fail(ParameterError, 'Client api version must be v4', caller) unless @client.api_version == 'v4'
      fail(ParameterError, 'No domain given to update tracking settings on Mailgun', caller) unless domain
      fail(ParameterError, 'No selector given to activate key on Mailgun', caller) unless selector
      @client.put("domains/#{domain}/keys/#{selector}/deactivate", {}).to_h
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
      fail(ParameterError, 'Client api version must be v1', caller) unless @client.api_version == 'v1'
      @client.post("dkim/keys", options).to_h
    end

    # Public: Delete a domain key.
    #
    # options - [Hash] of
    #   signing_domain - [Integer] Name of the domain (ex. domain.com)
    #   selector - [String] Name of the selector
    #
    # Returns [Hash] with message key
    def delete_domain_key(options = {})
      fail(ParameterError, 'Client api version must be v1', caller) unless @client.api_version == 'v1'
      @client.delete("dkim/keys", options).to_h
    end

    # Public: Returns total stats for a given domains
    #
    # domain    - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   event - [String] The type of the event.
    #   start - [String] The starting time. Should be in RFC 2822 or unix epoch format.
    #   end - [String] The ending date. Should be in RFC 2822 or unix epoch format
    #   resolution - [String] Can be either hour, day or month. Default: day
    #   duration - [String] Period of time with resoluton encoded
    #
    # Returns [Array] A list of domains (hash)
    def get_domain_stats(domain, options = {})
      fail(ParameterError, 'No domain given to list stats on Mailgun', caller) unless domain
      @client.get("#{domain}/stats/total", options).to_h
    end
  end
end
