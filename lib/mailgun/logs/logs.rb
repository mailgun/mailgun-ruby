# frozen_string_literal: true

module Mailgun
  # A Mailgun::Logs object is a simple interface to Mailgun Logs.
  # Uses Mailgun
  class Logs
    # Public: creates a new Mailgun::Logs instance.
    # Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new(Mailgun.api_key, Mailgun.api_host || 'api.mailgun.net', 'v1'))
      @client = client
    end

    # Public: Post query to get account logs
    #
    # options - [Hash] of
    #     start - [String] The start date (default: 1 day before current time). Must be in RFC 2822 format.
    #     end - [String] The end date (default: current time). Must be in RFC 2822 format.
    #     events - [Array] The set of events to include.
    #     metric_events - [Array] Optional set of analytics metric events. Will be converted into corresponding events.
    #     filter - [Object]
    #         AND: - [Array] of objects
    #             attribute - [String]
    #             comparator - [String]
    #             values - [Array] of objects
    #                 label - [String]
    #                 value - [String]
    #     include_subaccounts - [Boolean] Include logs from all subaccounts.
    #     include_totals - [Boolean] Include total number of log entries.
    #     pagination - [Object]
    #         sort - [String] Colon-separated value indicating column name and sort direction e.g. 'timestamp:desc'.
    #         token - [String] A token to the requested page.
    #         limit - [Integer] The maximum number of items returned (100 max).
    #
    # Returns [Hash] Logs
    def account_logs(options = {})
      @client.post('analytics/logs', options.to_json, { 'Content-Type' => 'application/json' }).to_h!
    end
  end
end
