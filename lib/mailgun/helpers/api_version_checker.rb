# frozen_string_literal: true

module Mailgun
  module ApiVersionChecker
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Both declarations can be placed before or after the methods they name.
    module ClassMethods
      def requires_api_version(version, *method_names)
        wrap_with_api_version_check(method_names) { warn_unless_api_version(version) }
      end

      def enforces_api_version(version, *method_names)
        wrap_with_api_version_check(method_names) { require_api_version(version) }
      end

      private

      # Prepends a module whose methods run the check and then the class's own method
      # through super, so the class methods don't have to exist yet.
      def wrap_with_api_version_check(method_names, &check)
        prepend(Module.new do
          method_names.each do |method_name|
            define_method(method_name) do |*args, **kwargs, &block|
              instance_exec(&check)
              super(*args, **kwargs, &block)
            end
          end
        end)
      end
    end

    private

    def warn_unless_api_version(expected_version)
      warn("WARN: Client api version must be #{expected_version}") unless @client.api_version == expected_version
    end

    def require_api_version(expected_version)
      return if @client.api_version == expected_version

      raise(ParameterError, "Client api version must be #{expected_version}",
            caller)
    end
  end
end
