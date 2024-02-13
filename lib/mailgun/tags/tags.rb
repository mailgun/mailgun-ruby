require 'mailgun/exceptions/exceptions'

module Mailgun

  # A Mailgun::Tags object is a simple CRUD interface to Mailgun Tags.
  # Uses Mailgun
  class Tags

    # Public: creates a new Mailgun::Tags instance.
    # Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new)
      @client = client
    end

    # Public: Get Tags
    #
    # domain - [String] Domain name where tag is stored
    # options - [Hash] of
    #    limit  - [Integer] Number of entries to return. Default: 100.
    #
    # Returns [Array] A list of tags (hash)
    def get_tags(domain, options = {})
      fail(ParameterError, 'No domain given to store template on', caller) unless domain
      @client.get("#{domain}/tags", options).to_h['items']
    end

    # Public: Get tag information
    #
    # domain - [String] Domain name where tag is stored
    # tag    - [String] Tag name to lookup for
    #
    # Returns [Hash] Information on the requested tag.
    def get_tag(domain, tag)
      fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
      fail(ParameterError, 'No tag name given to find on provided domain', caller) unless tag
      @client.get("#{domain}/tags/#{tag}").to_h!
    end

    # Public: Updates a given tag with the information provided
    #
    # domain - [String] Domain name where tag is stored
    # tag    - [String] Tag name to lookup for
    # options - [Hash] of
    #     description - [String] Updated description of the tag
    #
    # Returns [Boolean] if successful or not
    def update(domain, tag, options = {})
      fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
      fail(ParameterError, 'No tag name given to find on provided domain', caller) unless tag
      @client.put("#{domain}/tags/#{tag}", options).to_h['message'] == 'Tag updated'
    end

    # Public: Get statistics for a given tag
    #
    # domain - [String] Domain name where tag is stored
    # tag    - [String] Tag name to lookup for
    # options - [Hash] of
    #     event - [String] The type of the event. Required. (ex. accepted, delivered, failed, opened)
    #     start - [String] The starting time. Should be in RFC 282 or unix epoch format. Default: 7 days from the current time.
    #     end   - [String] The ending date. Should be in RFC 2822 or unix epoch time in seconds. Default: current time.
    #     resolution   - [String] Can be either hour, day or month. Default: day
    #     duration   - [String] Period of time with resolution encoded. If provided, overwrites the start date and resolution.
    #
    # Returns [Hash] of tag stats info
    def get_tag_stats(domain, tag, options = {})
      fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
      fail(ParameterError, 'No tag name given to find on provided domain', caller) unless tag
      @client.get("#{domain}/tags/#{tag}/stats", options).to_h
    end

    # Public: Delete Tag
    # NOTE: Deletes the tag. Note: The statistics for the tag are not destroyed.
    #
    # domain - [String] Domain name where tag is stored
    # tag    - [String] Tag name to lookup for
    #
    # Returns [Boolean] if successful or not
    def remove(domain, tag)
      fail(ParameterError, 'No domain given to remove on Mailgun', caller) unless domain
      fail(ParameterError, 'No template name given to find on provided domain', caller) unless tag
      @client.delete("#{domain}/tags/#{tag}").to_h['message'] == 'Tag deleted'
    end

    # Public: Get a list of countries of origin for a given domain for different event types.
    #
    # domain - [String] Domain name where tag is stored
    # tag    - [String] Tag name to lookup for
    #
    # Returns [Hash] of countries of origin for a given domain
    def get_countries_aggregated_stats(domain, tag)
      fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
      fail(ParameterError, 'No tag name given to find on provided domain', caller) unless tag
      @client.get("#{domain}/tags/#{tag}/stats/aggregates/countries").to_h
    end

    # Public: Get a list of email providers for a given domain for different event types
    #
    # domain - [String] Domain name where tag is stored
    # tag    - [String] Tag name to lookup for
    #
    # Returns [Hash] of email providers for a given domain
    def get_providers_aggregated_stats(domain, tag)
      fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
      fail(ParameterError, 'No tag name given to find on provided domain', caller) unless tag
      @client.get("#{domain}/tags/#{tag}/stats/aggregates/providers").to_h
    end

    # Public: Get a list of devices for a given domain that have triggered event types.
    #
    # domain - [String] Domain name where tag is stored
    # tag    - [String] Tag name to lookup for
    #
    # Returns [Hash] of devices for a given domain
    def get_devices_aggregated_stats(domain, tag)
      fail(ParameterError, 'No domain given to find on Mailgun', caller) unless domain
      fail(ParameterError, 'No tag name given to find on provided domain', caller) unless tag
      @client.get("#{domain}/tags/#{tag}/stats/aggregates/devices").to_h
    end
  end
end
