module Mailgun

  class ParameterError < RuntimeError
    attr_reader :object

    def initialize(message=nil, object=nil)
      @object = object
    end
  end

  class CommunicationError < RuntimeError
    attr_reader :object

    def initialize(message=nil, object=nil)
      @object = object
    end
  end

  class ParseError < RuntimeError
    attr_reader :object

    def initialize(message=nil, object=nil)
      @object = object
    end
  end

end
