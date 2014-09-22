require 'json'
require 'uri'
require 'base64'
require 'openssl'

module Mailgun

  class OptInHandler

    # Generates a hash that can be used to validate opt-in recipients. Encodes
    # all the necessary data in the URL.
    #
    # @param [String] mailing_list The mailing list the user should be subscribed to.
    # @param [String] secret_app_id A secret passphrase used as a constant for the hash.
    # @param [Hash] recipient_address The address of the user that should be subscribed.
    # @return [String] A url encoded URL suffix hash.

    def self.generate_hash(mailing_list, secret_app_id, recipient_address)
      innerPayload = {'l' => mailing_list,
                      'r' => recipient_address}

      innerPayloadEncoded = Base64.encode64(JSON.generate(innerPayload))

      sha1_digest = OpenSSL::Digest.new('sha1')
      digest = OpenSSL::HMAC.hexdigest(sha1_digest, secret_app_id, innerPayloadEncoded)

      outerPayload = {'h' => digest,
                      'p' => innerPayloadEncoded}

      outerPayloadEncoded = Base64.encode64(JSON.generate(outerPayload))

      URI.escape(outerPayloadEncoded)
    end

    # Validates the hash provided from the generate_hash method.
    #
    # @param [String] secret_app_id A secret passphrase used as a constant for the hash.
    # @param [Hash] unique_hash The hash from the user. Likely via link click.
    # @return [Hash or Boolean] A hash with 'recipient_address' and 'mailing_list', if validates. Otherwise, boolean false.

    def self.validate_hash(secret_app_id, unique_hash)
      outerPayload = JSON.parse(Base64.decode64(URI.unescape(unique_hash)))

      sha1_digest = OpenSSL::Digest.new('sha1')
      generated_hash = OpenSSL::HMAC.hexdigest(sha1_digest, secret_app_id, outerPayload['p'])

      innerPayload = JSON.parse(Base64.decode64(URI.unescape(outerPayload['p'])))

      hash_provided = outerPayload['h']

      if(generated_hash == hash_provided)
        return {'recipient_address' => innerPayload['r'], 'mailing_list' => innerPayload['l']}
      else
        return false
      end
    end

  end
  
end
