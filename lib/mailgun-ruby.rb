# frozen_string_literal: true

require_relative 'mailgun'
require_relative 'railgun' if defined?(Rails) && defined?(ActionMailer)
