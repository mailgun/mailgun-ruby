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

    # Public: initialization of new error given a message and/or object
    #
    # message - a String detailing the error
    # object  - a RestClient::Reponse object
    #
    def initialize(message = nil, object = nil)
      @object = object
      @code = object.http_code || NOCODE
      super(JSON.parse(object.body)['message'])
    rescue NoMethodError, JSON::ParserError
      @code = NOCODE
      super(message)
    end

  end
end
