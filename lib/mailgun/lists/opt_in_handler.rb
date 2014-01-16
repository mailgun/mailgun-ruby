require 'digest'
require 'json'
require 'uri'
require 'base64'

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
      hash = {'s' => Digest::MD5.hexdigest("#{secret_app_id}#{recipient_address}"),
              'l' => mailing_list,
              'r' => recipient_address}

      URI.escape(Base64.encode64(JSON.generate(hash)))
    end

    # Validates the hash provided from the generate_hash method.
    #
    # @param [String] secret_app_id A secret passphrase used as a constant for the hash.
    # @param [Hash] unique_hash The hash from the user. Likely via link click.
    # @return [Hash or Boolean] A hash with 'recipient_address' and 'mailing_list', if validates. Otherwise, boolean false.

    def self.validate_hash(secret_app_id, unique_hash)
      url_parameters = JSON.parse(Base64.decode64(URI.unescape(unique_hash)))
      generated_hash = Digest::MD5.hexdigest("#{secret_app_id}#{url_parameters['r']}")
      hash_provided = url_parameters['s']

      if(generated_hash == hash_provided)
        return {'recipient_address' => url_parameters['r'], 'mailing_list' => url_parameters['l']}
      else
        return false
      end
    end

  end
  
end
