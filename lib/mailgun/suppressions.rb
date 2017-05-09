require 'uri'

require 'mailgun/exceptions/exceptions'

module Mailgun

  # The Mailgun::Suppressions object makes it easy to manage "suppressions"
  # attached to an account. "Suppressions" means bounces, unsubscribes, and complaints.
  class Suppressions

    # @param [Mailgun::Client] client API client to use for requests
    # @param [String] domain Domain name to use for the suppression endpoints.
    def initialize(client, domain)
      @client = client
      @domain = domain

      @paging_next = nil
      @paging_prev = nil
    end

    ####
    # Paging operations
    ####

    def next
      response = get_from_paging @paging_next[:path], @paging_next[:params]
      extract_paging response
      response
    end

    def prev
      response = get_from_paging @paging_prev[:path], @paging_prev[:params]
      extract_paging response
      response
    end

    ####
    # Bounces Endpoint (/v3/:domain/bounces)
    ####

    def list_bounces(params = {})
      response = @client.get("#{@domain}/bounces", params)
      extract_paging response
      response
    end

    def get_bounce(address)
      @client.get("#{@domain}/bounces/#{address}", nil)
    end

    def create_bounce(params = {})
      @client.post("#{@domain/bounces}", params)
    end

    # Creates multiple bounces on the Mailgun API.
    # If a bounce does not have a valid structure, it will be added to a list of unsendable bounces.
    # The list of unsendable bounces will be returned at the end of this operation.
    #
    # If more than 999 bounce entries are provided, the list will be split and recursive calls will be made.
    #
    # @param [Array] data Array of bounce hashes
    # @return [Response] Mailgun API response
    # @return [Array] Return values from recursive call for list split.
    def create_bounces(data)
      # `data` should be a list of hashes, with each hash containing *at least* an `address` key.
      split_return = []
      if data.length >= 1000 then
        resp, resp_l = create_bounces data[999..-1]
        split_return.push(resp)
        split_return.concat(resp_l)
        data = data[0..998]
      elsif data.length == 0 then
        return nil, []
      end

      valid = []
      # Validate the bounces given
      # NOTE: `data` could potentially be very large (1000 elements) so it is
      # more efficient to pop from data and push into a different array as
      # opposed to possibly copying the entire array to another array.
      while not data.empty? do
        bounce = data.pop
        # Bounces MUST contain a `address` key.
        if not bounce.include? :address then
          raise Mailgun::ParameterError.new "Bounce MUST include a :address key: #{bounce}"
        end

        bounce.each do |k, v|
          # Hash values MUST be strings.
          if not v.is_a? String then
            bounce[k] = v.to_s
          end
        end

        valid.push bounce
      end

      response = @client.post("#{@domain}/bounces", valid.to_json, { "Content-Type" => "application/json" })
      return response, split_return
    end

    def delete_bounce(address)
      @client.delete("#{@domain}/bounces/#{address}")
    end

    def delete_all_bounces
      @client.delete("#{@domain}/bounces")
    end

    ####
    # Unsubscribes Endpoint (/v3/:domain/unsubscribes)
    ####

    def list_unsubscribes(params = {})
      response = @client.get("#{@domain}/unsubscribes", params)
      extract_paging response
      response
    end

    def get_unsubscribe(address)
      @client.get("#{@domain}/unsubscribes/#{address}")
    end

    def create_unsubscribe(params = {})
      @client.post("#{@domain}/unsubscribes", params)
    end

    # Creates multiple unsubscribes on the Mailgun API.
    # If an unsubscribe does not have a valid structure, it will be added to a list of unsendable unsubscribes.
    # The list of unsendable unsubscribes will be returned at the end of this operation.
    #
    # If more than 999 unsubscribe entries are provided, the list will be split and recursive calls will be made.
    #
    # @param [Array] data Array of unsubscribe hashes
    # @return [Response] Mailgun API response
    # @return [Array] Return values from recursive call for list split.
    def create_unsubscribes(data)
      # `data` should be a list of hashes, with each hash containing *at least* an `address` key.
      split_return = []
      if data.length >= 1000 then
        resp, resp_l = create_unsubscribes data[999..-1]
        split_return.push(resp)
        split_return.concat(resp_l)
        data = data[0..998]
      elsif data.length == 0 then
        return nil, []
      end

      valid = []
      # Validate the unsubscribes given
      while not data.empty? do
        unsubscribe = data.pop
        # unsubscribes MUST contain a `address` key.
        if not unsubscribe.include? :address then
          raise Mailgun::ParameterError.new "Unsubscribe MUST include a :address key: #{unsubscribe}"
        end

        unsubscribe.each do |k, v|
          # Hash values MUST be strings.
          if not v.is_a? String then
            unsubscribe[k] = v.to_s
          end
        end

        valid.push unsubscribe
      end

      response = @client.post("#{@domain}/unsubscribes", valid.to_json, { "Content-Type" => "application/json" })
      return response, split_return
    end

    def delete_unsubscribe(address, params = {})
      @client.delete("#{@domain}/unsubscribes/#{address}")
    end

    ####
    # Complaints Endpoint (/v3/:domain/complaints)
    ####

    def list_complaints(params = {})
      response = @client.get("#{@domain}/complaints", params)
      extract_paging response
      response
    end

    def get_complaint(address)
      @client.get("#{@domain}/complaints/#{address}", nil)
    end

    def create_complaint(params = {})
      @client.post("#{@domain}/complaints", params)
    end

    # Creates multiple complaints on the Mailgun API.
    # If a complaint does not have a valid structure, it will be added to a list of unsendable complaints.
    # The list of unsendable complaints will be returned at the end of this operation.
    #
    # If more than 999 complaint entries are provided, the list will be split and recursive calls will be made.
    #
    # @param [Array] data Array of complaint hashes
    # @return [Response] Mailgun API response
    # @return [Array] Return values from recursive call for list split.
    def create_complaints(data)
      # `data` should be a list of hashes, with each hash containing *at least* an `address` key.
      split_return = []
      if data.length >= 1000 then
        resp, resp_l = create_complaints data[999..-1]
        split_return.push(resp)
        split_return.concat(resp_l)
        data = data[0..998]
      elsif data.length == 0 then
        return nil, []
      end

      valid = []
      # Validate the complaints given
      while not data.empty? do
        complaint = data.pop
        # complaints MUST contain a `address` key.
        if not complaint.include? :address then
          raise Mailgun::ParameterError.new "Complaint MUST include a :address key: #{complaint}"
        end

        complaint.each do |k, v|
          # Hash values MUST be strings.
          if not v.is_a? String then
            complaint[k] = v.to_s
          end
        end

        valid.push complaint
      end

      response = @client.post("#{@domain}/complaints", valid.to_json, { "Content-Type" => "application/json" })
      return response, split_return
    end

    def delete_complaint(address)
      @client.delete("#{@domain}/complaints/#{address}")
    end

    private

    def get_from_paging(uri, params = {})
      @client.get(uri, params)
    end

    def extract_paging(response)
      rhash = response.to_h
      return nil unless rhash.include? "paging"

      page_info = rhash["paging"]

      # Build the `next` endpoint
      page_next = URI.parse(page_info["next"])
      @paging_next = {
        :path => page_next.path[/\/v[\d](.+)/, 1],
        :params => Hash[URI.decode_www_form page_next.query],
      }

      # Build the `prev` endpoint
      page_prev = URI.parse(page_info["previous"])
      @paging_prev = {
        :path => page_prev.path[/\/v[\d](.+)/, 1],
        :params => Hash[URI.decode_www_form page_prev.query],
      }
    end

  end
end
