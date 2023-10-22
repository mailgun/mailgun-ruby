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

    # Public: Update the metadata information of the template
    #
    # domain        - [String] Domain name where template is stored
    # template_name - [String] Template name to lookup for
    # options - [Hash] of
    #     description - [String] Updated description of the template
    #
    # Returns [Hash] of updated domain
    def update(domain, template_name, options = {})
      fail(ParameterError, 'No domain given to add on Mailgun', caller) unless domain
      fail(ParameterError, 'No template name given to find on provided domain', caller) unless template_name
      @client.put("#{domain}/templates/#{template_name}", options).to_h
    end

    # Public: Delete Template
    # NOTE: This method deletes all versions of the specified template.
    #
    # domain        - [String] Domain name where template is stored
    # template_name - [String] Template name to lookup for
    #
    # Returns [Boolean] if successful or not
    def remove(domain, template_name)
      fail(ParameterError, 'No domain given to remove on Mailgun', caller) unless domain
      fail(ParameterError, 'No template name given to find on provided domain', caller) unless template_name
      @client.delete("#{domain}/templates/#{template_name}").to_h['message'] == 'template has been deleted'
    end
    alias_method :delete, :remove
    alias_method :delete_template, :remove

    # Public: Get Templates
    #
    # domain - [String] Domain name where template is stored
    # page   - [String] Name of a page to retrieve. first, last, next, prev
    # limit  - [Integer] Maximum number of records to return. (100 by default)
    # p      - [Integer] Pivot is used to retrieve records in chronological order
    #
    # Returns [Array] A list of templates (hash)
    def list(domain, options = {})
      fail(ParameterError, 'No domain given.', caller) unless domain
      @client.get("#{domain}/templates", options).to_h['items']
    end
    alias_method :get_templates, :list

    # Public: Delete Templates
    # NOTE: This method deletes all stored templates for the domain.
    #
    # domain        - [String] Domain name where template is stored
    #
    # Returns [Boolean] if successful or not
    def remove_all(domain)
      fail(ParameterError, 'No domain given to remove on Mailgun', caller) unless domain
      @client.delete("#{domain}/templates").to_h['message'] == 'templates have been deleted'
    end
    alias_method :delete_templates, :remove_all

    # Public: Create a new version of a template
    #
    # domain        - [String] Name of the domain for new template(ex. domain.com)
    # template_name - [String] Template name to lookup for
    # options - [Hash] of
    #     template      - [String] Content of the template
    #     tag           - [String] Initial tag of the created version.
    #     comment       - [String] (Optional) Version comment.
    #     active        - [Boolean] (Optional) If this flag is set to yes, this version becomes active
    #     headers       - [String] (Optional) Key Value json dictionary of headers to be stored with the template.
    #                     ex.('{"Subject": "{{subject}}"}')
    #
    # Returns [Hash] of updated template
    def create_version(domain, template_name, options = {})
      fail(ParameterError, 'No domain given.', caller) unless domain
      fail(ParameterError, 'No template name given.', caller) unless template_name
      @client.post("#{domain}/templates/#{template_name}/versions", options).to_h
    end

    # Public: Get template version information
    #
    # domain        - [String] Domain name where template is stored
    # template_name - [String] Template name to lookup for
    # tag           - [String] Version tag to lookup for
    #
    # Returns [Hash] Information on the requested template + version.
    def info_version(domain, template_name, tag)
      fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
      fail(ParameterError, 'No template name given to find on provided domain', caller) unless template_name
      fail(ParameterError, 'No version tag given.', caller) unless tag
      @client.get("#{domain}/templates/#{template_name}/versions/#{tag}").to_h!
    end

    # Public: Update the version of the template
    #
    # domain        - [String] Domain name where template is stored
    # template_name - [String] Template name to lookup for
    # tag           - [String] Version tag to lookup for
    # options - [Hash] of
    #     template      - [String] Content of the template
    #     comment       - [String] (Optional) Version comment.
    #     active        - [Boolean] (Optional) If this flag is set to yes, this version becomes active
    #     headers       - [String] (Optional) Key Value json dictionary of headers to be stored with the template.
    #                     ex.('{"Subject": "{{subject}}"}')
    #
    # Returns [Hash] of updated template's version
    def update_version(domain, template_name, tag, options = {})
      fail(ParameterError, 'No domain given.', caller) unless domain
      fail(ParameterError, 'No template name given to find on provided domain.', caller) unless template_name
      fail(ParameterError, 'No version tag given.', caller) unless tag
      @client.put("#{domain}/templates/#{template_name}/versions/#{tag}", options).to_h
    end

    # Public: Delete the version of the template
    #
    # domain        - [String] Domain name where template is stored
    # template_name - [String] Template name to lookup for
    # tag           - [String] Version tag to lookup for
    #
    # Returns [Boolean] if successful or not
    def delete_version(domain, template_name, tag)
      fail(ParameterError, 'No domain given.', caller) unless domain
      fail(ParameterError, 'No template name given to find on provided domain.', caller) unless template_name
      fail(ParameterError, 'No version tag given.', caller) unless tag
      @client.delete("#{domain}/templates/#{template_name}/versions/#{tag}")
        .to_h['message'] == 'version has been deleted'
    end

    # Public: Get Template's Versions list
    #
    # domain        - [String] Domain name where template is stored
    # template_name - [String] Template name to lookup for
    # options - [Hash] of
    # page   - [String] Name of a page to retrieve. first, last, next, prev
    # limit  - [Integer] Maximum number of records to return. (100 by default)
    # p      - [Integer] Pivot is used to retrieve records in chronological order
    #
    # Returns [Array] A list of template's versions (hash)
    def template_versions_list(domain, template_name, options = {})
      fail(ParameterError, 'No domain given.', caller) unless domain
      fail(ParameterError, 'No template name given to find on provided domain.', caller) unless template_name
      @client.get("#{domain}/templates/#{template_name}/versions", options).to_h
    end
  end
end
