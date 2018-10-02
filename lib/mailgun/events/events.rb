require 'mailgun/exceptions/exceptions'

module Mailgun

  # A Mailgun::Events object makes it really simple to consume
  #   Mailgun's events from the Events endpoint.
  #
  # This is not yet comprehensive.
  #
  # Examples
  #
  #    See the Github documentation for full examples.
  class Events
    include Enumerable

    # Public: event initializer
    #
    # client - an instance of Mailgun::Client
    # domain - the domain to build queries
    def initialize(client, domain)
      @client = client
      @domain = domain
      @paging_next = nil
      @paging_previous = nil
    end

    # Public: Issues a simple get against the client. Alias of `next`.
    #
    # params - a Hash of query options and/or filters.
    #
    # Returns a Mailgun::Response object.
    def get(params = nil)
      self.next(params)
    end

    # Public: Using built in paging, obtains the next set of data.
    # If an events request hasn't been sent previously, this will send one
    #   without parameters
    #
    # params - a Hash of query options and/or filters.
    #
    # Returns a Mailgun::Response object.
    def next(params = nil)
      get_events(params, @paging_next)
    end

    # Public: Using built in paging, obtains the previous set of data.
    # If an events request hasn't been sent previously, this will send one
    #   without parameters
    #
    # params - a Hash of query options and/or filters.
    #
    # Returns Mailgun::Response object.
    def previous(params = nil)
      get_events(params, @paging_previous)
    end

    # Public: Allows iterating through all events and performs automatic paging.
    #
    # &block - Block to execute on items.
    def each(&block)
      items = self.next.to_h['items']

      until items.empty?
        items.each(&block)
        items = self.next.to_h['items']
      end
    end

    private

    # Internal: Makes and processes the event request through the client
    #
    # params - optional Hash of query options
    # paging - the URL key used for previous/next requests
    #
    # Returns a Mailgun.Response object.
    def get_events(params = nil, paging = nil)
      response = @client.get(construct_url(paging), params)
      extract_paging(response)
      response
    end

    # Internal: given an event response, pull and store the paging keys
    #
    # response - a Mailgun::Response object
    #
    # Return is irrelevant.
    def extract_paging(response)
      paging            = response.to_h['paging']
      next_page_url     = paging && paging['next']      # gives nil when any one of the keys doens't exist
      previous_page_url = paging && paging['previous']  # can be replaced with Hash#dig for ruby >= 2.3.0
      @paging_next      = extract_endpoint_from(next_page_url)
      @paging_previous  = extract_endpoint_from(previous_page_url)
    end

    # Internal: given a paging URL, extract the endpoint
    #
    # response - the endpoint for the previous/next page
    #
    # Returns a String of the partial URI if the given url follows the regular API format
    # Returns nil in other cases (e.g. when given nil, or an irrelevant url)
    def extract_endpoint_from(url = nil)
      URI.parse(url).path[/\/v[\d]\/#{@domain}\/events\/(.+)/,1]
    rescue URI::InvalidURIError
      nil
    end

    # Internal: construct the event path to be used by the client
    #
    # paging - the URL key for previous/next set of results
    #
    # Returns a String of the partial URI
    def construct_url(paging = nil)
      return "#{@domain}/events/#{paging}" if paging
      "#{@domain}/events"
    end

  end
end
