module ApiVersionChecker
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Declarative method to specify API version requirements for methods
    # Usage: requires_api_version 'v4', :list, :info, :verify
    def requires_api_version(version, *methods)
      @api_version_requirements ||= {}
      methods.each do |method_name|
        @api_version_requirements[method_name] = version
      end

      # Hook into method definitions to add version checking
      methods.each do |method_name|
        if method_defined?(method_name)
          wrap_method_with_version_check(method_name, version)
        end
      end
    end

    # Alternative syntax: enforces_api_version 'v4', :get_domain_keys (raises error instead of warning)
    def enforces_api_version(version, *methods)
      @api_version_enforcements ||= {}
      methods.each do |method_name|
        @api_version_enforcements[method_name] = version
      end

      methods.each do |method_name|
        if method_defined?(method_name)
          wrap_method_with_version_enforcement(method_name, version)
        end
      end
    end

    private

    def wrap_method_with_version_check(method_name, version)
      original_method = instance_method(method_name)
      define_method(method_name) do |*args, **kwargs, &block|
        warn_unless_api_version(version)
        if kwargs.empty?
          original_method.bind(self).call(*args, &block)
        else
          original_method.bind(self).call(*args, **kwargs, &block)
        end
      end
    end

    def wrap_method_with_version_enforcement(method_name, version)
      original_method = instance_method(method_name)
      define_method(method_name) do |*args, **kwargs, &block|
        require_api_version(version)
        if kwargs.empty?
          original_method.bind(self).call(*args, &block)
        else
          original_method.bind(self).call(*args, **kwargs, &block)
        end
      end
    end

    # Hook that runs whenever a method is defined
    def method_added(method_name)
      super

      # Check if this method needs version requirements
      if @api_version_requirements&.key?(method_name)
        version = @api_version_requirements[method_name]
        wrap_method_with_version_check(method_name, version)
      end

      if @api_version_enforcements&.key?(method_name)
        version = @api_version_enforcements[method_name]
        wrap_method_with_version_enforcement(method_name, version)
      end
    end
  end

  private

  def warn_unless_api_version(expected_version)
    warn("WARN: Client api version must be #{expected_version}") unless @client.api_version == expected_version
  end

  def require_api_version(expected_version)
    fail(ParameterError, "Client api version must be #{expected_version}", caller) unless @client.api_version == expected_version
  end
end
