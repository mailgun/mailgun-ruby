module Railgun

  class Error < StandardError

    attr_reader :object

    def initialize(message = nil, object = nil)
      super(message)

      @object = object
    end
  end

  class ConfigurationError < Error
  end

  class InternalError < Error

    attr_reader :source_exception

    def initialize(source_exc, message = nil, object = nil)
      super(message, object)

      @source_exception = source_exc
    end
  end
end
