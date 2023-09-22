require 'mailgun/exceptions/exceptions'

module Mailgun

  # A Mailgun::Templates object is a simple CRUD interface to Mailgun Templates.
  # Uses Mailgun
  class Templates

    # Public: creates a new Mailgun::Templates instance.
    # Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new)
      @client = client
    end

    # Public: Add template
    #
    # domain  - [String] Name of the domain for new template(ex. domain.com)
    # options - [Hash] of
    #     name - [String] Name of the template being stored.
    #     description   - [String] Description of the template being stored
    #     template      - [String] (Optional) Content of the template
    #     tag           - [String] (Optional) Initial tag of the created version.
    #     comment       - [String] (Optional) Version comment.
    #     headers       - [String] (Optional) Key Value json dictionary of headers to be stored with the template.
    #                     ex.('{"Subject": "{{subject}}"}')
    #
    # Returns [Hash] of created template
    def create(domain, options = {})
      fail(ParameterError, 'No domain given to store template on', caller) unless domain
      @client.post("#{domain}/templates", options).to_h
    end

    # Public: Get template information
    #
    # domain        - [String] Domain name where template is stored
    # template_name - [String] Template name to lookup for
    # options - [Hash] of
    #     active - [Boolean] (Optional) If this flag is set to yes the active version
    #               of the template is included in the response.
    #
    # Returns [Hash] Information on the requested template.
    def info(domain, template_name, options = {})
      fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
      fail(ParameterError, 'No template name given to find on provided domain', caller) unless template_name
      @client.get("#{domain}/templates/#{template_name}", options).to_h!
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

    # Public: Delete Domain
    #
    # domain - [String] domain name to delete (ex. domain.com)
    #
    # Returns [Boolean] if successful or not
    def remove(domain)
      fail(ParameterError, 'No domain given to remove on Mailgun', caller) unless domain
      @client.delete("domains/#{domain}").to_h['message'] == "Domain will be deleted on the background"
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
      fail(ParameterError, 'No domain given to add on Mailgun', caller) unless domain
      @client.put("domains/#{domain}", options).to_h
    end
  end
end
