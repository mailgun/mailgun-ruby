require 'mail'
require 'mailgun/messages/message_builder'
require 'railgun/attachment'
require 'railgun/errors'

module Mail

  class Message

    # Attributes to hold Mailgun-specific information
    attr_accessor :mailgun_variables,
                  :mailgun_options,
                  :mailgun_recipient_variables,
                  :mailgun_headers

  end
end
