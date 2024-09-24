module Mailgun

  # Public: A basic class for mananging errors.
  # Inherits from StandardError (previously RuntimeError) as not all errors are
  # runtime errors.
  class Error < StandardError

    # Public: get an object an error is instantiated with
    attr_reader :object

    # Public: initialize a Mailgun:Error object
    #
    # message - a String describing the error
    # object  - an object with details about the error
    def initialize(message = nil, object = nil)
      super(message)
      @object = object
    end
  end

  # Public: Class for managing parameter errors, with a pretty name.
  # Inherits from Mailgun::Error
  class ParameterError < Error; end

  # Public: Class for managing parsing errors, with a pretty name.
  # Inherits from Mailgun::Error
  class ParseError < Error; end

  # Public: Class for managing communications (eg http) response errors
  # Inherits from Mailgun::Error
  class CommunicationError < Error
    # Public: gets HTTP status code
    attr_reader :code

    # Public: fallback if there is no response code on the object
    NOCODE = 000
    FORBIDDEN = 'Forbidden'

    # Public: initialization of new error given a message and/or object
    #
    # message  - a String detailing the error
    # response - a RestClient::Response object
    #
    def initialize(message = nil, response = nil)
      @response = response
      @code = if response.nil?
                NOCODE
              else
                response.code
              end

      begin
        json = JSON.parse(response.body)
        api_message = json['message'] || json['Error'] || json['error']
      rescue JSON::ParserError
        api_message = response.body
      rescue NoMethodError
        api_message = "Unknown API error"
      rescue
        api_message = 'Unknown API error'
      end

      message = message || ''
      message = message + ': ' + (api_message || "")

      super(message, response)
    rescue NoMethodError, JSON::ParserError
      @code = NOCODE
      super(message, response)
    end
  end

  # Public: Class for managing unauthorized 401 errors
  # Inherits from Mailgun::CommunicationError
  class Unauthorized < CommunicationError
    CODE = 401

    def initialize(error_message, response)
      error_message = error_message + ' - Invalid Domain or API key'
      super(error_message, response)
    end
  end

  # Public: Class for managing bad request 400 errors
  # Inherits from Mailgun::CommunicationError
  class BadRequest < CommunicationError
    CODE = 400

    def initialize(error_message, response)
      super(error_message, response)
    end
  end
end
