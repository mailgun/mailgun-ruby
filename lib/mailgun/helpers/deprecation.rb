# frozen_string_literal: true

module Mailgun
  # Prints the gem's deprecation warnings in one format, e.g.
  #
  #   app/jobs/report.rb:12: warning: DEPRECATION: "Mailgun::Tags#get_tag" is deprecated
  #   (Mailgun deprecated the Tags API) and will be removed in mailgun-ruby 1.5.
  #   Please use "Mailgun::AnalyticsTags#list" instead.
  #
  # The location is the first caller outside the gem, so it points at the code to change.
  module Deprecation
    GEM_LIB_DIR = "#{File.expand_path('../..', __dir__)}/".freeze

    # Public: Warn that a method or class is deprecated
    #
    # name        - [String] The deprecated method or class, e.g. "Mailgun::Tags#get_tag"
    # replacement - [String] What to use instead, e.g. "Mailgun::AnalyticsTags#list"
    # reason      - [String] Why, when Mailgun deprecated the API it calls (optional)
    # removal     - [String] When it will be removed, e.g. "mailgun-ruby 1.5" (optional)
    #
    # Returns nil
    def self.warn(name, replacement, reason: nil, removal: nil)
      message = "DEPRECATION: \"#{name}\" is deprecated"
      message += " (#{reason})" if reason
      message += " and will be removed in #{removal}" if removal
      message += ". Please use \"#{replacement}\" instead."

      location = caller_locations.find { |loc| !(loc.absolute_path || loc.path).to_s.start_with?(GEM_LIB_DIR) }
      Kernel.warn(location ? "#{location.path}:#{location.lineno}: warning: #{message}" : message)
    end
  end
end
