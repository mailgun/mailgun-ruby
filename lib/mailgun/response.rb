require 'ostruct'

module Mailgun
  # A Mailgun::Response object is instantiated for each response generated
  # by the Client request. The Response object supports deserialization of
  # the JSON result. Or, if you prefer JSON or YAML formatting, call the
  # method for conversion.
  #
  # See the Github documentation for full examples.
  class Response
    # All responses have a payload and a code corresponding to http, though
    #   slightly different
    attr_accessor :body, :code

    def self.from_hash(h)
      # Create a "fake" response object with the data passed from h
      self.new OpenStruct.new(h)
    end

    def initialize(response)
      @body = response.body
      @code = response.code
    end

    # Return response as Ruby Hash
    #
    # @return [Hash] A standard Ruby Hash containing the HTTP result.

    def to_h
      JSON.parse(@body)
    rescue => err
      raise ParseError.new(err), err
    end

    # Replace @body with Ruby Hash
    #
    # @return [Hash] A standard Ruby Hash containing the HTTP result.
    def to_h!
      @body = JSON.parse(@body)
    rescue => err
      raise ParseError.new(err), err
    end

    # Return response as Yaml
    #
    # @return [String] A string containing response as YAML
    def to_yaml
      YAML.dump(to_h)
    rescue => err
      raise ParseError.new(err), err
    end

    # Replace @body with YAML
    #
    # @return [String] A string containing response as YAML
    def to_yaml!
      @body = YAML.dump(to_h)
    rescue => err
      raise ParseError.new(err), err
    end
  end
end
