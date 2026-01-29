# frozen_string_literal: true

# require ruby dependencies
require 'json'

# require external dependencies
require 'action_mailer'
require 'mail'
require 'mailgun'
require 'rails'

module Railgun
  require_relative 'railgun/attachment'
  require_relative 'railgun/errors'
  require_relative 'railgun/mailer'
  require_relative 'railgun/railtie'
end
