module Railgun
  class Railtie < ::Rails::Railtie
    ActiveSupport.on_load(:action_mailer) do
      Mail::Message.class_eval do
        # Attributes to hold Mailgun-specific information
        attr_accessor :mailgun_variables,
                      :mailgun_options,
                      :mailgun_recipient_variables,
                      :mailgun_headers,
                      :mailgun_template_variables
      end

      add_delivery_method :mailgun, Railgun::Mailer
      ActiveSupport.run_load_hooks(:mailgun_mailer, Railgun::Mailer)
    end
  end
end
