require 'mailgun/exceptions/exceptions'

module Mailgun

  # A Mailgun::Subaccounts object is a simple CRUD interface to Mailgun Subaccounts.
  # Uses Mailgun
  class Subaccounts
    attr_reader :client

    # Public: creates a new Mailgun::Subaccounts instance.
    # Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new(Mailgun.api_key, Mailgun.api_host || 'api.mailgun.net', 'v5'))
      @client = client
    end

    # Public: Get subaccounts
    # options - [Hash] of
    #     limit  - [Integer] Maximum number of records to return. (10 by default)
    #     skip     [Integer] Number of records to skip
    #     sort     [Array] “asc” or “desc”
    #     enabled  [boolean] (Optional) Returns all enabled/disabled subaccounts, defaults to all if omitted
    #     headers       - [String] (Optional) Key Value json dictionary of headers to be stored with the subaccount.
    #                     ex.('{"Subject": "{{subject}}"}')
    #
    # Returns [Array] A list of subaccounts (hash)
    def list(options = {})
      client.get("accounts/subaccounts", options).to_h!
    end
    alias_method :get_subaccounts, :list

    # Public: Get subaccount information
    #
    # subaccount_id - [String] subaccount name to lookup for
    # options - [Hash] of
    #     headers       - [String] (Optional) Key Value json dictionary of headers to be stored with the subaccount.
    #                     ex.('{"Subject": "{{subject}}"}')
    #
    # Returns [Hash] Information on the requested subaccount.
    def info(subaccount_id, options = {})
      fail(ParameterError, 'No Id of subaccount specified', caller) unless subaccount_id
      client.get("accounts/subaccounts/#{subaccount_id}", options).to_h!
    end

    # Public: Add Subaccount
    #
    # name  - [String] Name of the subaccount being created
    # options - [Hash] of
    #     name - [String] Name of the subaccount being created.
    #     headers       - [String] (Optional) Key Value json dictionary of headers to be stored with the subaccount.
    #                     ex.('{"Subject": "{{subject}}"}')
    #
    # Returns [Hash] of created subaccount
    def create(name, options = {})
      fail(ParameterError, 'No name given to create subaccount', caller) unless name
      client.post("accounts/subaccounts", options.merge!(name: name)).to_h!
    end

    # Public: Disable a subaccount
    #
    # subaccount_id - [String] subaccount name to disable
    # options - [Hash] of
    #     headers       - [String] (Optional) Key Value json dictionary of headers to be stored with the subaccount.
    #                     ex.('{"Subject": "{{subject}}"}')
    #
    # Returns [Hash] Information on the requested subaccount.
    def disable(subaccount_id, options = {})
      fail(ParameterError, 'No Id of subaccount specified', caller) unless subaccount_id
      client.post("accounts/subaccounts/#{subaccount_id}/disable", options).to_h!
    end

    # Public: Enable a subaccount
    #
    # subaccount_id - [String] subaccount name to enable
    # options - [Hash] of
    #     headers       - [String] (Optional) Key Value json dictionary of headers to be stored with the subaccount.
    #                     ex.('{"Subject": "{{subject}}"}')
    #
    # Returns [Hash] Information on the requested subaccount.
    def enable(subaccount_id, options = {})
      fail(ParameterError, 'No Id of subaccount specified', caller) unless subaccount_id
      client.post("accounts/subaccounts/#{subaccount_id}/enable", options).to_h!
    end
  end
end
