require 'mailgun/exceptions/exceptions'

module Mailgun

  # Mailgun::Address is a simple interface to the Email Validation API.
  class Address
    def initialize
      @client = Mailgun::Client.new(Mailgun.api_key, Mailgun.api_host || 'api.mailgun.net', 'v4')
    end

    # Given an arbitrary address, validates it based on defined checks.
    #
    # @param [String] address Email address to validate (max 512 chars.)
    def validate(address, mailbox_verification = false)
      params = {address:  address}
      params[:mailbox_verification] = true if mailbox_verification

      res = @client.get "address/validate", params
      return res.to_h!
    end
  end

end
