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
    SUBACCOUNT_HEADER = 'X-Mailgun-On-Behalf-Of'.freeze

    def initialize(api_key = Mailgun.api_key,
                   api_host = Mailgun.api_host || 'api.mailgun.net',
                   api_version = Mailgun.api_version  || 'v3',
                   ssl = true,
                   test_mode = false,
                   timeout = nil,
                   proxy_url = Mailgun.proxy_url)

      rest_client_params = {
        user: 'api',
        password: api_key,
        user_agent: "mailgun-sdk-ruby/#{Mailgun::VERSION}"
      }
      rest_client_params[:timeout] = timeout if timeout

      endpoint = endpoint_generator(api_host, api_version, ssl)
      RestClient.proxy = proxy_url
      @http_client = RestClient::Resource.new(endpoint, rest_client_params)
      @test_mode = test_mode
      @api_version = api_version
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

    # Change API key
    def set_api_key(api_key)
      @http_client.options[:password] = api_key
    end

    # Add subaccount id to headers
    def set_subaccount(subaccount_id)
      @http_client.options[:headers] = { SUBACCOUNT_HEADER => subaccount_id }
    end

    # Reset subaccount for primary usage
    def reset_subaccount
      @http_client.options[:headers].delete(SUBACCOUNT_HEADER)
    end

    # Client is in test mode?
    #
    # @return [Boolean] Is the client set in test mode?
    def test_mode?
      @test_mode
    end

    # @return [String] client api version
    def api_version
      @api_version
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
      perform_data_validation(working_domain, data)

      if test_mode? then
        Mailgun::Client.deliveries << data
        return Response.from_hash(
          {
            :body => "{\"id\": \"test-mode-mail-#{SecureRandom.uuid}@localhost\", \"message\": \"Queued. Thank you.\"}",
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
    def delete(resource_path, params = nil)
      if params
        response = @http_client[resource_path].delete(params: params)
      else
        response = @http_client[resource_path].delete
      end
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
      if e.respond_to?(:response) && e.response
        return case e.response.code
        when Unauthorized::CODE
          Unauthorized.new(e.message, e.response)
        when BadRequest::CODE
          BadRequest.new(e.message, e.response)
        else
          CommunicationError.new(e.message, e.response)
        end
      end
      CommunicationError.new(e.message)
    end

    def perform_data_validation(working_domain, data)
      message = data.respond_to?(:message) ? data.message : data
      fail ParameterError.new('Missing working domain', working_domain) unless working_domain
      fail ParameterError.new(
        'Missing `to` recipient, message should contain at least 1 recipient',
        working_domain
      ) if message.fetch('to', []).empty? && message.fetch(:to, []).empty?
      fail ParameterError.new(
        'Missing a `from` sender, message should contain at least 1 `from` sender',
        working_domain
      ) if message.fetch('from', []).empty? && message.fetch(:from, []).empty?
    end
  end
end
