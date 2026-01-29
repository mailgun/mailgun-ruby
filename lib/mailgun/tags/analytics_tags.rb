module Mailgun
  # A Mailgun::AnalyticsTags object is a simple CRUD interface to Mailgun Tags.
  # Uses Mailgun
  class AnalyticsTags
    include ApiVersionChecker

    # Public: creates a new Mailgun::AnalyticsTags instance.
    # Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new(Mailgun.api_key, Mailgun.api_host || 'api.mailgun.net', 'v1'))
      @client = client
    end

    # Public: Update account tag
    #
    # tag - [String] The tag to update.
    # description - [String] The updated tag description.
    #
    # Returns [Boolean] true or false
    def update(tag, description)
      @client.put('analytics/tags', { tag: tag, description: description }.to_json,
                  { 'Content-Type' => 'application/json' }).to_h['message'] == 'Tag updated'
    end

    # Public: Post query to list account tags or search for single tag
    #
    # options - [Hash] of
    #     include_subaccounts  - [Boolean] Boolean indicating whether or not to include data from all subaccounts. Default false.
    #     include_metrics      - [Boolean] Boolean indicating whether or not to include metrics for tags. Default false. When true max limit is 20.
    #     tag                  - [string] The tag or tag prefix.
    #     pagination           - [Object]
    #         sort          - [String] Colon-separated value indicating column name and sort direction e.g. 'timestamp:desc'.
    #         skip          - [Integer] The number of items to skip over when satisfying the request.
    #         limit         - [Integer] The maximum number of items returned (100 max).
    #         total         - [Integer] The total number of tags matching the search criteria.
    #         include_total - [Boolean] Boolean indicating whether or not to include total number of items. Default false.

    #
    # Returns [Hash] Information on the requested tags.
    def list(options = {})
      @client.post('analytics/tags', options).to_h['items']
    end

    # Public: Delete account tag
    #
    # tag - [String] The tag to delete.
    #
    # Returns [Boolean] true or false
    def remove(tag)
      @client.delete('analytics/tags', { tag: tag }, body_params: true).to_h['message'] == 'Tag deleted'
    end

    # Public: Get account tag limit information
    #
    # Returns [Hash] Information on the tag limits.
    def limits
      @client.get('analytics/tags/limits').to_h
    end

    enforces_api_version 'v1', :update, :list, :remove, :limits
  end
end
