module Mailgun
  module ApiVersionChecker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def requires_api_version(version, *method_names)
        method_names.each do |method_name|
          original_method = instance_method(method_name)

          define_method(method_name) do |*args, &block|
            warn_unless_api_version(version)
            original_method.bind(self).call(*args, &block)
          end
        end
      end

      def enforces_api_version(version, *method_names)
        method_names.each do |method_name|
          original_method = instance_method(method_name)

          define_method(method_name) do |*args, &block|
            require_api_version(version)
            original_method.bind(self).call(*args, &block)
          end
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
end
