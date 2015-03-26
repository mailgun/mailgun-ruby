module Mailgun
  
  # A Mailgun::Domains object is a simple CRUD interface to Mailgun Domains.
  
  class Domains
    
    def initialize(client)
      @client = client
    end
    
    # Get Domains
    #
    # @param [Integer] limit Maximum number of records to return. (100 by default)
    # @param [Integer] skip Number of records to skip. (0 by default)
    # @return [Array] A list of domains
    
    def get_domains(options={})
      params = URI.encode_www_form options
      response = @client.get "/domains?#{params}"
      JSON.parse(response.body)['items']
    end
    
    # Get Domain
    #
    # @param [String] domain Domain name
    # @return [Hash] Informations on the requested domains
        
    def get_domain(options)
      domain = options[:domain]
      response = @client.get "/domains/#{domain}"
      JSON.parse(response.body)
    end
    
    # Verify Domain
    #
    # @param [String] domain Domain name
    # @return [Hash] Informations on the requested domains
    
    def verify_domain(options)
      domain = options[:domain]
      response = @client.put "domains/#{domain}/verify", nil
      JSON.parse(response.body)
    end
    
    # Add Domain
    #
    # @param [String] name Name of the domain (ex. domain.com)
    # @param [String] smtp_password Password for SMTP authentication
    # @param [String] spam_action disabled or tag Disable, no spam filtering will occur for inbound messages. Tag, messages will be tagged wtih a spam header. See Spam Filter.
    # @param [Boolean] wildcard true or false Determines whether the domain will accept email for sub-domains.
    
    def add_domain(options)
      @client.post('/domains', URI.encode_www_form(options))
    end
    
    # Delete Domain
    #
    # @param [String] domain Name of the domain (ex. domain.com)
    
    def delete_domain(options)
      domain = options[:domain]
      @client.delete("/domains/#{domain}")
    end
    
  end
end