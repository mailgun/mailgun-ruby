# frozen_string_literal: true

module Mailgun
  # A Mailgun::Routes object is a simple CRUD interface to Mailgun Routes, the rules
  # that handle incoming email.
  # Uses Mailgun
  class Routes
    include ApiVersionChecker

    enforces_api_version 'v3', :list, :create, :get, :update, :remove, :match

    # Public: creates a new Mailgun::Routes instance.
    # Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new)
      @client = client
    end

    # Public: Get routes
    #
    # options - [Hash] of
    #   limit - [Integer] Maximum number of records to return. (100 by default)
    #   skip  - [Integer] Number of records to skip. (0 by default)
    #
    # Returns [Array] A list of routes (hash)
    def list(options = {})
      @client.get('routes', options).to_h['items']
    end

    # Public: Create a route
    #
    # options - [Hash] of
    #   expression  - [String] The filtering rule, e.g. match_recipient(".*@example.com")
    #   action      - [String, Array] Action(s) to take when the expression matches,
    #                 e.g. forward("https://example.com/messages") or stop()
    #   priority    - [Integer] Smaller numbers are handled first. Defaults to 0
    #   description - [String] Route description
    #
    # Returns [Hash] of the created route
    def create(options = {})
      @client.post('routes', options).to_h
    end

    # Public: Get a route
    #
    # route_id - [String] ID of the route
    #
    # Returns [Hash] Information on the requested route
    def get(route_id)
      require_route_id!(route_id, 'No route ID given to find')

      @client.get("routes/#{route_id}").to_h!
    end

    # Public: Update a route
    #
    # route_id - [String] ID of the route
    # options - [Hash] of
    #   expression  - [String] The filtering rule
    #   action      - [String, Array] Action(s) to take when the expression matches
    #   priority    - [Integer] Smaller numbers are handled first
    #   description - [String] Route description
    #
    # Returns [Hash] of the updated route
    def update(route_id, options = {})
      require_route_id!(route_id, 'No route ID given to update')

      @client.put("routes/#{route_id}", options).to_h
    end

    # Public: Delete a route
    #
    # route_id - [String] ID of the route
    #
    # Returns [Boolean] if successful or not
    def remove(route_id)
      require_route_id!(route_id, 'No route ID given to remove')

      @client.delete("routes/#{route_id}").status == 200
    end

    # Public: Find the route that handles an address
    #
    # address - [String] Email address to match against the routes
    #
    # Returns [Hash] with the matching route
    def match(address)
      raise(ParameterError, 'No address given to match', caller) if address.nil? || address.to_s.empty?

      @client.get('routes/match', { address: address }).to_h
    end

    private

    def require_route_id!(route_id, message)
      raise(ParameterError, message, caller) if route_id.nil? || route_id.to_s.empty?
    end
  end
end
