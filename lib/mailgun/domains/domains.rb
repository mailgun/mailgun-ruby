module Mailgun

  # A Mailgun::Domains object is a simple CRUD interface to Mailgun Domains.
  # Uses Mailgun
  class Domains
    include ApiVersionChecker

    # Public: creates a new Mailgun::Domains instance.
    #   Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new)
      @client = client
    end

    # ==== Core Domains methods ====

    # Public: Get Domains
    #
    # limit - [Integer] Maximum number of records to return. (100 by default)
    # skip  - [Integer] Number of records to skip. (0 by default)
    #
    # Returns [Array] A list of domains (hash)
    def list(options = {})
      @client.get('domains', options).to_h['items']
    end

    def get_domains
      warn('The `get_domains` method will be deprecated in future versions of Mailgun. Please use `list` instead.')
      list
    end

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
      options = { smtp_password: nil, spam_action: 'disabled', wildcard: false }.merge(options)
      options[:name] = domain
      @client.post('domains', options).to_h
    end

    def add(domain, options = {})
      warn('The `add` method will be deprecated in future versions of Mailgun. Please use `create` instead.')
      create(domain, options)
    end

    def add_domain(domain, options = {})
      warn('The `add_domain` method will be deprecated in future versions of Mailgun. Please use `create` instead.')
      create(domain, options)
    end

    # Public: Get domain information
    #
    # domain - [String] Domain name to lookup
    #
    # Returns [Hash] Information on the requested domains.
    def get(domain)
      @client.get("domains/#{domain}").to_h!
    end

    def info(domain)
      warn('The `info` method will be deprecated in future versions of Mailgun. Please use `get` instead.')
      get(domain)
    end

    def get_domain(domain)
      warn('The `get_domain` method will be deprecated in future versions of Mailgun. Please use `get` instead.')
      get(domain)
    end

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
      @client.put("domains/#{domain}", options).to_h
    end


    # Public: Verify domain
    #
    # domain - [String] Domain name
    #
    # Returns [Hash] Information on the updated/verified domains
    def verify(domain)
      @client.put("domains/#{domain}/verify", nil).to_h!
    end

    def verify_domain(domain)
      warn('The `verify_domain` method will be deprecated in future versions of Mailgun. Please use `verify` instead.')
      verify(domain)
    end

    # Public: Delete Domain
    #
    # domain - [String] domain name to delete (ex. domain.com)
    #
    # Returns [Boolean] if successful or not
    def remove(domain)
      @client.delete("domains/#{domain}").to_h['message'] == 'Domain has been deleted'
    end

    def delete(domain)
      warn('The `delete` method will be deprecated in future versions of Mailgun. Please use `remove` instead.')
      remove(domain)
    end

    def delete_domain(domain)
      warn('The `delete_domain` method will be deprecated in future versions of Mailgun. Please use `remove` instead.')
      remove(domain)
    end

    # ==== End of Core Domains methods ====

    # ==== Domain::Keys methods ====

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
      @client.get("dkim/keys", options).to_h
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
      @client.delete("dkim/keys", options).to_h
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

    # ==== End of Domain::Keys methods ====

    # ==== Domain::Tracking methods ====

    # Public: Returns tracking settings for the defined domain.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    #
    # Returns [Hash] Information on the tracking settings
    def get_domain_tracking_settings(domain)
      @client.get("domains/#{domain}/tracking").to_h
    end

    # Public: Updates the click tracking settings for a domain.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   active  - [Boolean] yes or no. If set to yes, links will be overwritten and pointed to our servers so we can track clicks.
    #
    # Returns [Hash] Information on the tracking click settings
    def update_domain_tracking_click_settings(domain, options = {})
      @client.put("domains/#{domain}/tracking/click", options).to_h
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
      @client.put("domains/#{domain}/tracking/open", options).to_h
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
      @client.put("domains/#{domain}/tracking/unsubscribe", options).to_h
    end

    # Public: Tracking Certificate: Get certificate and status
    #
    # domain - [String] The tracking domain of the TLS certificate, formatted as web_prefix.domain_name
    #
    # Returns [Hash] Status of certificate. Either 'expired' 'processing' 'active' or 'error'
    def get_domain_tracking_certificate(domain)
      @client.get("x509/#{domain}/status").to_h
    end

    # Tracking Certificate: Regenerate expired certificate
    #
    # domain - [String] The tracking domain of the TLS certificate, formatted as web_prefix.domain_name
    #
    # Returns [Hash] A message indicating the status of the request.
    def regenerate_domain_tracking_certificate(domain, options = {})
      @client.put("x509/#{domain}", options).to_h
    end

    # Public: Tracking Certificate: Generate
    #
    # domain - [String] The tracking domain of the TLS certificate, formatted as web_prefix.domain_name
    #
    # Returns [Hash] A message indicating the status of the request.
    def generate_domain_tracking_certificate(domain, options = {})
      @client.post("x509/#{domain}", options).to_h
    end

    # ==== End of Domain::Tracking methods ====


    # ==== Domain::DKIM_Security methods ====

    # Public: Tracking Certificate: Generate
    #
    # domain - [String] The Domain name
    # rotation_enabled - [Boolean] If true, enables DKIM Auto-Rotation. If false, disables it
    #
    # options - [Hash] of
    #   rotation_interval - [String] The interval at which to rotate keys. Example, '5d' for five days
    #
    # Returns [Hash] domain object
    def dkim_rotation(domain, rotation_enabled, options = {})
      options = { rotation_enabled: rotation_enabled }.merge(options)
      @client.put("dkim_management/domains/#{domain}/rotation", options)
    end

    # Public: Rotate Automatic Sender Security DKIM key for a domain
    #
    # domain - [String] The Domain name
    #
    # Returns [Hash] Response message
    def dkim_rotate(domain)
      @client.post("dkim_management/domains/#{domain}/rotate", {})
    end

    # ==== End of Domain::DKIM_Security methods ====

    # ==== Credentials methods ====

    # Public: Creates a new set of SMTP credentials for the defined domain.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   login  - [String] The user name (ex. bob.bar)
    #   password  - [String] A password for the SMTP credentials. (Length Min 5, Max 32)
    #
    # Returns [Hash] with message key
    def create_smtp_credentials(domain, options = {})
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
      @client.put("domains/#{domain}/credentials/#{login}", options).to_h
    end

    # Public: Deletes the defined SMTP credentials.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # login  - [String] The user name (ex. bob.bar)
    #
    # Returns [Hash] with message and spec keys
    def delete_smtp_credentials(domain, login)
      @client.delete("domains/#{domain}/credentials/#{login}").to_h
    end

    # ==== End of Credentials methods ====

    # ==== Reporting::Stat methods ====

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

    # ==== End of Reporting::Stats methods ====

    # ==== Deprecated methods ====

    # Public: Returns delivery connection settings for the defined domain.
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    #
    # Returns [Hash] Information on the delivery connection settings
    def get_domain_connection_settings(domain)
      warn('The `get_domain_connection_settings` method is deprecated in and wiil be removed in the future version of Mailgun.')
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
      warn('The `update_domain_connection_settings` method is deprecated in and wiil be removed in the future version of Mailgun.')
      @client.put("domains/#{domain}/connection", options).to_h
    end

    # Public: Update the CNAME used for tracking opens and clicks
    #
    # domain  - [String] Name of the domain (ex. domain.com)
    # options - [Hash] of
    #   web_prefix  - [String] change the tracking CNAME for a domain.
    #
    # Returns [Hash] with message key
    def update_domain_web_prefix(domain, options = {})
      warn('The `update_domain_web_prefix` method is deprecated in and wiil be removed in the future version of Mailgun.')
      @client.put("domains/#{domain}/web_prefix", options).to_h
    end

    # ==== End of Deprecated methods ====




    enforces_api_version 'v1', :list_domain_keys, :create_domain_key, :delete_domain_key, :dkim_rotation,
                         :dkim_rotate
    enforces_api_version 'v2', :get_domain_tracking_certificate, :regenerate_domain_tracking_certificate,
                         :generate_domain_tracking_certificate
    enforces_api_version 'v3', :remove, :create_smtp_credentials, :update_smtp_credentials,
                         :delete_smtp_credentials, :get_domain_connection_settings,
                         :update_domain_connection_settings, :get_domain_tracking_settings,
                         :update_domain_tracking_open_settings, :update_domain_tracking_click_settings,
                         :update_domain_tracking_unsubscribe_settings, :update_domain_dkim_authority,
                         :update_domain_dkim_selector, :update_domain_web_prefix, :get_domain_stats
    enforces_api_version 'v4', :get_domain_keys, :activate_domain_key, :deactivate_domain_key,
                         :list, :info, :verify, :create, :update
  end
end
