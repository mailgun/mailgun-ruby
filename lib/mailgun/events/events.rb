require 'mailgun'
require "mailgun/exceptions/exceptions"


module Mailgun

  # A Mailgun::Events object makes it really simple to consume
  # Mailgun's events from the Events endpoint.
  #
  #
  # See the Github documentation for full examples.

  class Events

    def initialize(client, domain)
      @client = client
      @domain = domain
      @paging_next = nil
      @paging_previous = nil
    end

    # Issues a simple get against the client.
    #
    # @param [Hash] params A hash of query options and/or filters.
    # @return [Mailgun::Response] Mailgun Response object.

    def get(params=nil)
      _get(params)
    end

    # Using built in paging, obtains the next set of data.
    #
    # @return [Mailgun::Response] Mailgun Response object.

    def next()
      _get(nil, @paging_next)
    end

    # Using built in paging, obtains the previous set of data.
    #
    # @return [Mailgun::Response] Mailgun Response object.

    def previous()
      _get(nil, @paging_previous)
    end

    private

    def _get(params=nil, paging=nil)
      response = @client.get(construct_url(paging), params)
      extract_paging(response)
      response
    end

    def extract_paging(response)
      paging_next = response.to_h["paging"]["next"]
      paging_previous = response.to_h["paging"]["previous"]

      # This is pretty hackish. But the URL will never change in API v2.
      @paging_next = paging_next.split("/")[6]
      @paging_previous = paging_previous.split("/")[6]
    end

    def construct_url(paging=nil)
      if paging
        "#{@domain}/events/#{paging}"
      else
        "#{@domain}/events"
      end
    end

  end

end
