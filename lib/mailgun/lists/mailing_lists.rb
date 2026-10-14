# frozen_string_literal: true

module Mailgun
  # A Mailgun::MailingLists object is a simple CRUD interface to Mailgun Mailing Lists
  # and their members.
  # Uses Mailgun
  class MailingLists
    include ApiVersionChecker

    # Public: creates a new Mailgun::MailingLists instance.
    # Defaults to Mailgun::Client
    def initialize(client = Mailgun::Client.new)
      @client = client
    end

    # Lists

    # Public: Get mailing lists
    #
    # options - [Hash] of
    #   limit   - [Integer] Maximum number of records to return. (100 by default)
    #   skip    - [Integer] Number of records to skip. (0 by default)
    #   address - [String] Return only the list with this address
    #
    # Returns [Array] A list of mailing lists (hash)
    def list(options = {})
      @client.get('lists', options).to_h['items']
    end

    # Public: Get mailing lists by page
    #
    # options - [Hash] of
    #   limit   - [Integer] Maximum number of records to return. (100 by default)
    #   page    - [String] Page to retrieve: first, last, next or prev
    #   address - [String] Pivot list address the page starts from
    #
    # Returns [Hash] with the mailing lists in 'items' and page URLs in 'paging'
    def list_pages(options = {})
      @client.get('lists/pages', options).to_h
    end

    # Public: Create a mailing list
    #
    # address - [String] Email address of the list, e.g. developers@mg.example.com
    # options - [Hash] of
    #   name             - [String] List name
    #   description      - [String] List description
    #   access_level     - [String] Who can post: readonly, members or everyone. Defaults to readonly
    #   reply_preference - [String] Where replies go: list or sender. Defaults to list
    #
    # Returns [Hash] of the created list
    def create(address, options = {})
      require_address!(address, 'No address given to create the mailing list')

      @client.post('lists', options.merge(address: address)).to_h
    end

    # Public: Get a mailing list
    #
    # address - [String] Email address of the list
    #
    # Returns [Hash] Information on the requested list
    def get(address)
      require_address!(address, 'No address given to find the mailing list')

      @client.get("lists/#{escape(address)}").to_h!
    end

    # Public: Update a mailing list
    #
    # address - [String] Email address of the list
    # options - [Hash] of
    #   address          - [String] New email address of the list
    #   name             - [String] List name
    #   description      - [String] List description
    #   access_level     - [String] Who can post: readonly, members or everyone
    #   reply_preference - [String] Where replies go: list or sender
    #
    # Returns [Hash] of the updated list
    def update(address, options = {})
      require_address!(address, 'No address given to update the mailing list')

      @client.put("lists/#{escape(address)}", options).to_h
    end

    # Public: Delete a mailing list and all of its members
    #
    # address - [String] Email address of the list
    #
    # Returns [Boolean] if successful or not
    def remove(address)
      require_address!(address, 'No address given to remove the mailing list')

      @client.delete("lists/#{escape(address)}").status == 200
    end

    # Members

    # Public: Get the members of a mailing list
    #
    # list_address - [String] Email address of the list
    # options - [Hash] of
    #   subscribed - [Boolean] Return only subscribed (true) or unsubscribed (false) members
    #   limit      - [Integer] Maximum number of records to return. (100 by default)
    #   skip       - [Integer] Number of records to skip. (0 by default)
    #   address    - [String] Return only the member with this address
    #
    # Returns [Array] A list of members (hash)
    def list_members(list_address, options = {})
      require_address!(list_address, 'No list address given to list members of')

      @client.get("lists/#{escape(list_address)}/members", options).to_h['items']
    end

    # Public: Get the members of a mailing list by page
    #
    # list_address - [String] Email address of the list
    # options - [Hash] of
    #   subscribed - [Boolean] Return only subscribed (true) or unsubscribed (false) members
    #   limit      - [Integer] Maximum number of records to return. (100 by default)
    #   page       - [String] Page to retrieve: first, last, next or prev
    #   address    - [String] Pivot member address the page starts from
    #
    # Returns [Hash] with the members in 'items' and page URLs in 'paging'
    def list_members_pages(list_address, options = {})
      require_address!(list_address, 'No list address given to list members of')

      @client.get("lists/#{escape(list_address)}/members/pages", options).to_h
    end

    # Public: Get a mailing list member
    #
    # list_address   - [String] Email address of the list
    # member_address - [String] Email address of the member
    #
    # Returns [Hash] Information on the requested member
    def get_member(list_address, member_address)
      require_address!(list_address, 'No list address given to find the member on')
      require_address!(member_address, 'No member address given to find')

      @client.get("lists/#{escape(list_address)}/members/#{escape(member_address)}").to_h!
    end

    # Public: Add a member to a mailing list
    #
    # list_address   - [String] Email address of the list
    # member_address - [String] Email address of the member
    # options - [Hash] of
    #   name       - [String] Member name
    #   vars       - [Hash, String] Custom member variables, a Hash or a JSON string
    #   subscribed - [Boolean] Whether the member is subscribed. Defaults to true
    #   upsert     - [Boolean] Update the member if it already exists instead of failing. Defaults to false
    #
    # Returns [Hash] of the created member
    def create_member(list_address, member_address, options = {})
      require_address!(list_address, 'No list address given to add the member to')
      require_address!(member_address, 'No member address given to add')

      @client.post("lists/#{escape(list_address)}/members",
                   encode_vars(options).merge(address: member_address)).to_h
    end

    # Public: Update a mailing list member
    #
    # list_address   - [String] Email address of the list
    # member_address - [String] Email address of the member
    # options - [Hash] of
    #   address    - [String] New email address of the member
    #   name       - [String] Member name
    #   vars       - [Hash, String] Custom member variables, a Hash or a JSON string
    #   subscribed - [Boolean] Whether the member is subscribed
    #
    # Returns [Hash] of the updated member
    def update_member(list_address, member_address, options = {})
      require_address!(list_address, 'No list address given to update the member on')
      require_address!(member_address, 'No member address given to update')

      @client.put("lists/#{escape(list_address)}/members/#{escape(member_address)}", encode_vars(options)).to_h
    end

    # Public: Remove a member from a mailing list
    #
    # list_address   - [String] Email address of the list
    # member_address - [String] Email address of the member
    #
    # Returns [Boolean] if successful or not
    def remove_member(list_address, member_address)
      require_address!(list_address, 'No list address given to remove the member from')
      require_address!(member_address, 'No member address given to remove')

      @client.delete("lists/#{escape(list_address)}/members/#{escape(member_address)}").status == 200
    end

    # Public: Add up to 1,000 members to a mailing list in one call
    #
    # list_address - [String] Email address of the list
    # members      - [Array, String] Members as an Array of addresses or member hashes
    #                (address, name, vars, subscribed), or a JSON string of the same
    # options - [Hash] of
    #   upsert - [Boolean] Update members that already exist instead of failing. Defaults to false
    #
    # Returns [Hash] with the list and a confirmation message
    def create_members(list_address, members, options = {})
      require_address!(list_address, 'No list address given to add members to')
      raise(ParameterError, 'No members given to add', caller) if members.nil? || members.empty?

      members = members.to_json unless members.is_a?(String)
      @client.post("lists/#{escape(list_address)}/members.json", options.merge(members: members)).to_h
    end

    # Public: Add up to 1,000 members to a mailing list from a CSV file
    #
    # list_address - [String] Email address of the list
    # csv          - [String, IO] Path to the CSV file, or an IO with its contents
    # options - [Hash] of
    #   subscribed - [Boolean] Subscription status for members without one in the file
    #   upsert     - [Boolean] Update members that already exist instead of failing. Defaults to false
    #
    # Returns [Hash] with the list and a confirmation message
    def import_members(list_address, csv, options = {})
      require_address!(list_address, 'No list address given to import members to')
      raise(ParameterError, 'No CSV file given to import members from', caller) if csv.nil? || csv == ''

      file = Faraday::Multipart::FilePart.new(csv, 'text/csv', csv.is_a?(String) ? File.basename(csv) : 'members.csv')
      @client.post("lists/#{escape(list_address)}/members.csv", options.merge(members: file)).to_h
    end

    enforces_api_version 'v3', :list, :list_pages, :create, :get, :update, :remove,
                         :list_members, :list_members_pages, :get_member, :create_member,
                         :update_member, :remove_member, :create_members, :import_members

    alias get_lists list
    alias delete remove
    alias add_member create_member
    alias delete_member remove_member

    private

    def require_address!(address, message)
      raise(ParameterError, message, caller) if address.nil? || address.to_s.empty?
    end

    # Percent-encodes the characters an email address may contain that would break a URL path,
    # keeping '@' and '+' as they are.
    def escape(address)
      address.to_s.gsub(%r{[%/?#\s]}) { |char| format('%%%02X', char.ord) }
    end

    def encode_vars(options)
      return options unless options[:vars].is_a?(Hash)

      options.merge(vars: options[:vars].to_json)
    end
  end
end
