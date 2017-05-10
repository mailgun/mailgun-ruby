require 'action_mailer'
require 'mailgun'
require 'rails'
require 'railgun/errors'

module Railgun

  # Railgun::Mailer is an ActionMailer provider for sending mail through
  # Mailgun.
  class Mailer

    # [Hash] config ->
    #   Requires *at least* `api_key` and `domain` keys.
    attr_accessor :config, :domain

    # Initialize the Railgun mailer.
    #
    # @param [Hash] config Hash of config values, typically from `app_config.action_mailer.mailgun_config`
    def initialize(config)
      @config = config

      [:api_key, :domain].each do |k|
        raise Railgun::ConfigurationError.new("Config requires `#{k}` key", @config) unless @config.has_key?(k)
      end

      @mg_client = Mailgun::Client.new(config[:api_key])
      @domain = @config[:domain]

      if (@config[:fake_message_send] || false)
        Rails.logger.info "NOTE: fake message sending has been enabled for mailgun-ruby!"
        @mg_client.enable_test_mode!
      end
    end

    def deliver!(mail)
      mg_message = Railgun.transform_for_mailgun(mail)
      response = @mg_client.send_message(@domain, mg_message)

      if response.code == 200 then
        mg_id = response.body['id']
        mail.message_id = mg_id
      end
      response
    end

    def mailgun_client
      @mg_obj
    end

  end

  module_function

  # Performs a series of transformations on the `mailgun*` attributes.
  # After prefixing them with the proper option type, they are added to
  # the message hash where they will then be sent to the API as JSON.
  #
  # @param [Mail::Message] mail message to transform
  #
  # @return [Hash] transformed message hash
  def transform_for_mailgun(mail)
    message = build_message_object(mail)

    # v:* attributes (variables)
    mail.mailgun_variables.try(:each) do |k, v|
      message["v:#{k}"] = v
    end

    # o:* attributes (options)
    mail.mailgun_options.try(:each) do |k, v|
      message["o:#{k}"] = v
    end

    # h:* attributes (headers)
    mail.mailgun_headers.try(:each) do |k, v|
      message["h:#{k}"] = v
    end

    # recipient variables
    message['recipient-variables'] = mail.mailgun_recipient_variables.to_json if mail.mailgun_recipient_variables

    # reject blank values
    message.delete_if do |k, v|
      v.nil? or (v.respond_to?(:empty) and v.empty?)
    end

    return message
  end

  # Acts on a Rails/ActionMailer message object and uses Mailgun::MessageBuilder
  # to construct a new message.
  #
  # @param [Mail::Message] mail message to transform
  #
  # @returns [Hash] Message hash from Mailgun::MessageBuilder
  def build_message_object(mail)
    mb = Mailgun::MessageBuilder.new

    mb.from mail[:from]
    mb.reply_to(mail[:reply_to].to_s) if mail[:reply_to].present?
    mb.subject mail.subject
    mb.body_html extract_body_html(mail)
    mb.body_text extract_body_text(mail)

    [:to, :cc, :bcc].each do |rcpt_type|
      addrs = mail[rcpt_type] || nil
      case addrs
      when String
        # Likely a single recipient
        mb.add_recipient rcpt_type.to_s, addrs
      when Array
        addrs.each do |addr|
          mb.add_recipient rcpt_type.to_s, addr
        end
      when Mail::Field
        mb.add_recipient rcpt_type.to_s, addrs.to_s
      end
    end

    return mb.message if mail.attachments.empty?

    mail.attachments.each do |attach|
      attach = Attachment.new(attach, encoding: 'ascii-8bit', inline: attach.inline?)
      attach.attach_to_message! mb
    end

    return mb.message
  end

  # Returns the decoded HTML body from the Mail::Message object if available,
  # otherwise nil.
  #
  # @param [Mail::Message] mail message to transform
  #
  # @return [String]
  def extract_body_html(mail)
    begin
      (mail.html_part || mail).body.decoded || nil
    rescue
      nil
    end
  end

  # Returns the decoded text body from the Mail::Message object if it is available,
  # otherwise nil.
  #
  # @param [Mail::Message] mail message to transform
  #
  # @return [String]
  def extract_body_text(mail)
    begin
      (mail.text_part || mail).body.decoded || nil
    rescue
      nil
    end
  end

end
