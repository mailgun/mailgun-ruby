# frozen_string_literal: true

module Mailgun
  # A Mailgun::Response object is instantiated for each response generated
  # by the Client request. The Response object supports deserialization of
  # the JSON result. Or, if you prefer JSON or YAML formatting, call the
  # method for conversion.
  #
  # See the Github documentation for full examples.
  class Response
    # All responses have a payload and a status corresponding to http, though
    #   slightly different
    attr_accessor :body, :status, :code

    ResponseHash = Struct.new(:body, :status)
    def self.from_hash(h)
      # Create a "fake" response object with the data passed from h
      new ResponseHash.new(h[:body], h[:status])
    end

    def initialize(response)
      @body = response.body
      @status = response.status
      @code = response.status
    end

    # Return response as Ruby Hash
    #
    # @return [Hash] A standard Ruby Hash containing the HTTP result.

    def to_h
      JSON.parse(@body)
    rescue StandardError => e
      raise ParseError.new(e), e
    end

    # Replace @body with Ruby Hash
    #
    # @return [Hash] A standard Ruby Hash containing the HTTP result.
    def to_h!
      @body = JSON.parse(@body)
    rescue StandardError => e
      raise ParseError.new(e), e
    end

    # Return response as Yaml
    #
    # @return [String] A string containing response as YAML
    def to_yaml
      YAML.dump(to_h)
    rescue StandardError => e
      raise ParseError.new(e), e
    end

    # Replace @body with YAML
    #
    # @return [String] A string containing response as YAML
    def to_yaml!
      @body = YAML.dump(to_h)
    rescue StandardError => e
      raise ParseError.new(e), e
    end

    # Returns true if response status is 2xx
    #
    # @return [Boolean] A boolean that binarizes the response status result.
    def success?
      (200..299).include?(status)
    end
  end
end
