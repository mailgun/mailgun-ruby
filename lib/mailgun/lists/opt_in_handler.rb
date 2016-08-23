require 'uri'
require 'base64'
require 'openssl'

module Mailgun

  # Public: Provides methods for creating and handling opt-in URLs,
  #   particularlly for mailing lists.
  #
  # See: https://github.com/mailgun/mailgun-ruby/blob/master/OptInHandler.md
  class OptInHandler

    # Generates a hash that can be used to validate opt-in recipients. Encodes
    # all the necessary data in the URL.
    #
    # @param [String] mailing_list The mailing list the user should be subscribed to.
    # @param [String] secret_app_id A secret passphrase used as a constant for the hash.
    # @param [Hash] recipient_address The address of the user that should be subscribed.
    # @return [String] A url encoded URL suffix hash.
    def self.generate_hash(mailing_list, secret_app_id, recipient_address)
      inner_payload = { 'l' => mailing_list, 'r' => recipient_address }

      inner_payload_encoded = Base64.encode64(JSON.generate(inner_payload))

      sha1_digest = OpenSSL::Digest.new('sha1')
      digest = OpenSSL::HMAC.hexdigest(sha1_digest, secret_app_id, inner_payload_encoded)

      outer_payload = { 'h' => digest, 'p' => inner_payload_encoded }

      outer_payload_encoded = Base64.encode64(JSON.generate(outer_payload))

      CGI.escape(outer_payload_encoded)
    end

    # Validates the hash provided from the generate_hash method.
    #
    # @param [String] secret_app_id A secret passphrase used as a constant for the hash.
    # @param [Hash] unique_hash The hash from the user. Likely via link click.
    # @return [Hash or Boolean] A hash with 'recipient_address' and 'mailing_list', if validates. Otherwise, boolean false.
    def self.validate_hash(secret_app_id, unique_hash)
      outer_payload = JSON.parse(Base64.decode64(CGI.unescape(unique_hash)))

      sha1_digest = OpenSSL::Digest.new('sha1')
      generated_hash = OpenSSL::HMAC.hexdigest(sha1_digest, secret_app_id, outer_payload['p'])

      inner_payload = JSON.parse(Base64.decode64(CGI.unescape(outer_payload['p'])))

      hash_provided = outer_payload['h']

      if generated_hash == hash_provided
        return { 'recipient_address' => inner_payload['r'], 'mailing_list' => inner_payload['l'] }
      end
      false
    end

  end

end
