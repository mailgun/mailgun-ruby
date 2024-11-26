require 'mailgun/exceptions/exceptions'

module Mailgun
  # A Mailgun::Metrics object is a simple interface to Mailgun Metrics.
  # Uses Mailgun
  class Metrics
    # Public: creates a new Mailgun::Metrics instance.
    # Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new(Mailgun.api_key, Mailgun.api_host || 'api.mailgun.net', 'v1'))
      @client = client
    end

    # Public: Post query to get account metrics
    #
    # options - [Hash] of
    #     start - [String] A start date (default: 7 days before current time). Must be in RFC 2822 format.
    #     end - [String] An end date (default: current time). Must be in RFC 2822 format.
    #     resolution - [String] A resolution in the format of 'day' 'hour' 'month'. Default is day.
    #     duration - [String] A duration in the format of '1d' '2h' '2m'. If duration is provided then it is calculated from the end date and overwrites the start date.
    #     dimensions - [Array] Attributes of the metric data such as 'subaccount'.
    #     metrics - [Array] Name of the metrics to receive the stats for such as 'processed_count'
    #     filter - [Object]
    #         AND: - [Array] of objects
    #             attribute - [String]
    #             comparator - [String]
    #             values - [Array] of objects
    #                 label - [String]
    #                 value - [String]
    #     include_subaccounts - [Boolean] Include stats from all subaccounts.
    #     include_aggregates - [Boolean] Include top-level aggregate metrics.
    #
    # Returns [Hash] Metrics
    def account_metrics(options={})
      @client.post('analytics/metrics', options.to_json, { "Content-Type" => "application/json" }).to_h!
    end

    # Public: Post query to get account usage metrics
    #
    # options - [Hash] of
    #     start - [String] A start date (default: 7 days before current time). Must be in RFC 2822 format.
    #     end - [String] An end date (default: current time). Must be in RFC 2822 format.
    #     resolution - [String] A resolution in the format of 'day' 'hour' 'month'. Default is day.
    #     duration - [String] A duration in the format of '1d' '2h' '2m'. If duration is provided then it is calculated from the end date and overwrites the start date.
    #     dimensions - [Array] Attributes of the metric data such as 'subaccount'.
    #     metrics - [Array] Name of the metrics to receive the stats for such as 'processed_count'
    #     filter - [Object]
    #         AND: - [Array] of objects
    #             attribute - [String]
    #             comparator - [String]
    #             values - [Array] of objects
    #                 label - [String]
    #                 value - [String]
    #     include_subaccounts - [Boolean] Include stats from all subaccounts.
    #     include_aggregates - [Boolean] Include top-level aggregate metrics.
    #
    # Returns [Hash] Metrics
    def account_usage_metrics(options={})
      @client.post('analytics/usage/metrics', options.to_json, { "Content-Type" => "application/json" }).to_h!
    end
  end
end
