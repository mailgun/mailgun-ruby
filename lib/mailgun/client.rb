require 'mailgun/chains'
require 'mailgun/suppressions'
require 'mailgun/exceptions/exceptions'

module Mailgun
  # A Mailgun::Client object is used to communicate with the Mailgun API. It is a
  # wrapper around RestClient so you don't have to worry about the HTTP aspect
  # of communicating with our API.
  #
  # See the Github documentation for full examples.
  class Client

    def initialize(api_key = Mailgun.api_key,
                   api_host = 'api.mailgun.net',
                   api_version = 'v3',
                   ssl = true,
                   test_mode = false,
                   timeout = nil)

      endpoint = endpoint_generator(api_host, api_version, ssl)
      @http_client = RestClient::Resource.new(endpoint,
                                              user: 'api',
                                              password: api_key,
                                              user_agent: "mailgun-sdk-ruby/#{Mailgun::VERSION}",
                                              timeout: timeout)
      @test_mode = test_mode
    end

    # Enable test mode
    #
    # Prevents sending of any messages.
    def enable_test_mode!
      @test_mode = true
    end

    # Disable test mode
    #
    # Reverts the test_mode flag and allows the client to send messages.
    def disable_test_mode!
      @test_mode = false
    end

    # Client is in test mode?
    #
    # @return [Boolean] Is the client set in test mode?
    def test_mode?
      @test_mode
    end

    # Provides a store of all the emails sent in test mode so you can check them.
    #
    # @return [Hash]
    def self.deliveries
      @@deliveries ||= []
    end

    # Simple Message Sending
    #
    # @param [String] working_domain This is the domain you wish to send from.
    # @param [Hash] data This should be a standard Hash
    # containing required parameters for the requested resource.
    # @return [Mailgun::Response] A Mailgun::Response object.
    def send_message(working_domain, data)
      if test_mode? then
        Mailgun::Client.deliveries << data
        return Response.from_hash(
          {
            :body => '{"id": "test-mode-mail@localhost", "message": "Queued. Thank you."}',
            :code => 200,
          }
        )
      end

      case data
      when Hash
        # Remove nil values from the data hash
        # Submitting nils to the API will likely cause an error.
        #  See also: https://github.com/mailgun/mailgun-ruby/issues/32
        data = data.select { |k, v| v != nil }

        if data.key?(:message)
          if data[:message].is_a?(String)
            data[:message] = convert_string_to_file(data[:message])
          end
          return post("#{working_domain}/messages.mime", data)
        end
        post("#{working_domain}/messages", data)
      when MessageBuilder
        post("#{working_domain}/messages", data.message)
      else
        fail ParameterError.new('Unknown data type for data parameter.', data)
      end
    end

    # Generic Mailgun POST Handler
    #
    # @param [String] resource_path This is the API resource you wish to interact
    # with. Be sure to include your domain, where necessary.
    # @param [Hash] data This should be a standard Hash
    # containing required parameters for the requested resource.
    # @param [Hash] headers Additional headers to pass to the resource.
    # @return [Mailgun::Response] A Mailgun::Response object.
    def post(resource_path, data, headers = {})
      response = @http_client[resource_path].post(data, headers)
      Response.new(response)
    rescue => err
      raise communication_error err
    end

    # Generic Mailgun GET Handler
    #
    # @param [String] resource_path This is the API resource you wish to interact
    # with. Be sure to include your domain, where necessary.
    # @param [Hash] params This should be a standard Hash
    # containing required parameters for the requested resource.
    # @param [String] accept Acceptable Content-Type of the response body.
    # @return [Mailgun::Response] A Mailgun::Response object.
    def get(resource_path, params = nil, accept = '*/*')
      if params
        response = @http_client[resource_path].get(params: params, accept: accept)
      else
        response = @http_client[resource_path].get(accept: accept)
      end
      Response.new(response)
    rescue => err
      raise communication_error err
    end

    # Generic Mailgun PUT Handler
    #
    # @param [String] resource_path This is the API resource you wish to interact
    # with. Be sure to include your domain, where necessary.
    # @param [Hash] data This should be a standard Hash
    # containing required parameters for the requested resource.
    # @return [Mailgun::Response] A Mailgun::Response object.
    def put(resource_path, data)
      response = @http_client[resource_path].put(data)
      Response.new(response)
    rescue => err
      raise communication_error err
    end

    # Generic Mailgun DELETE Handler
    #
    # @param [String] resource_path This is the API resource you wish to interact
    # with. Be sure to include your domain, where necessary.
    # @return [Mailgun::Response] A Mailgun::Response object.
    def delete(resource_path)
      response = @http_client[resource_path].delete
      Response.new(response)
    rescue => err
      raise communication_error err
    end

    # Constructs a Suppressions client for the given domain.
    #
    # @param [String] domain Domain which suppressions requests will be made for
    # @return [Mailgun::Suppressions]
    def suppressions(domain)
      Suppressions.new(self, domain)
    end

    private

    # Converts MIME string to file for easy uploading to API
    #
    # @param [String] string MIME string to post to API
    # @return [File] File object
    def convert_string_to_file(string)
      file = Tempfile.new('MG_TMP_MIME')
      file.write(string)
      file.rewind
      file
    end

    # Generates the endpoint URL to for the API. Allows overriding
    # API endpoint, API versions, and toggling SSL.
    #
    # @param [String] api_host URL endpoint the library will hit
    # @param [String] api_version The version of the API to hit
    # @param [Boolean] ssl True, SSL. False, No SSL.
    # @return [string] concatenated URL string
    def endpoint_generator(api_host, api_version, ssl)
      ssl ? scheme = 'https' : scheme = 'http'
      if api_version
        "#{scheme}://#{api_host}/#{api_version}"
      else
        "#{scheme}://#{api_host}"
      end
    end

    # Raises CommunicationError and stores response in it if present
    #
    # @param [StandardException] e upstream exception object
    def communication_error(e)
      return CommunicationError.new(e.message, e.response) if e.respond_to? :response
      CommunicationError.new(e.message)
    end

  end
end
