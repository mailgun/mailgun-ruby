module Mailgun

  class Error < RuntimeError
    attr_reader :object

    def initialize(message=nil, object=nil)
      @message = message
      @object = object
    end

    def to_s
      @message || self.class.to_s
    end
  end

  class ParameterError     < Error; end
  class CommunicationError < Error; end
  class ParseError         < Error; end

end
