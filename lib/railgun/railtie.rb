require 'railgun/mailer'

module Railgun
  class Railtie < ::Rails::Railtie
    initializer "railgun.configure_rails_initialization", before: 'action_mailer.set_configs' do
      ActionMailer::Base.add_delivery_method(:mailgun, Railgun::Mailer)
    end
  end
end
