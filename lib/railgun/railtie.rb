require 'railgun/mailer'

module Railgun
  class Railtie < ::Rails::Railtie
    ActiveSupport.on_load(:action_mailer) do
      add_delivery_method :mailgun, Railgun::Mailer
      ActiveSupport.run_load_hooks(:mailgun_mailer, Railgun::Mailer)
    end
  end
end
