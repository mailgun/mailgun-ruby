require 'mailgun/exceptions/exceptions'

module Mailgun

  # Mailgun::Address is a simple interface to the Email Validation API.
  class Address

    # @param [String] api_key Mailgun API - public key
    def initialize(api_key = "")
      if api_key == "" then
        fail ParameterError.new('Public API key is required for Mailgun::Address.initialize()', nil)
      end

      @api_key = api_key
      @client = Mailgun::Client.new(api_key = api_key)
    end

    # Given an arbitrary address, validates it based on defined checks.
    #
    # @param [String] address Email address to validate (max 512 chars.)
    def validate(address, mailbox_verification = false)
      params = {:address => address}
      params[:mailbox_verification] = true if mailbox_verification

      res = @client.get "address/validate", params
      return res.to_h!
    end

    # Parses a delimiter separated list of email addresses into two lists:
    # parsed addresses and unparsable portions. The parsed addresses are a
    # list of addresses that are syntactically valid (and optionally have
    # DNS and ESP specific grammar checks) the unparsable list is a list
    # of characters sequences that the parser was not able to understand.
    # These often align with invalid email addresses, but not always.
    # Delimiter characters are comma (,) and semicolon (;).
    #
    # @param [Array] addresses Addresses to parse
    # @param [TrueClass|FalseClass] syntax_only Perform only syntax checks
    def parse(addresses, syntax_only = true)
      validate_addrs = addresses.join(";")

      res = @client.get "address/parse", {:addresses => validate_addrs,
                                          :syntax_only => syntax_only.to_s}
      return res.to_h!
    end
  end

end
