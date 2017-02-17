require 'railgun/mailer'

module Railgun
  class Railtie < ::Rails::Railtie
    config.before_configuration do
      ActionMailer::Base.add_delivery_method :mailgun, Railgun::Mailer
    end
  end
end
