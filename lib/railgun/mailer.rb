require 'action_mailer'
require 'json'
require 'mailgun'
require 'rails'
require 'railgun/errors'

module Railgun

  # Railgun::Mailer is an ActionMailer provider for sending mail through
  # Mailgun.
  class Mailer

    # List of the headers that will be ignored when copying headers from `mail.header_fields`
    IGNORED_HEADERS = %w[ to from subject ]

    # [Hash] config ->
    #   Requires *at least* `api_key` and `domain` keys.
    attr_accessor :config, :domain, :settings

    # Initialize the Railgun mailer.
    #
    # @param [Hash] config Hash of config values, typically from `app_config.action_mailer.mailgun_config`
    def initialize(config)
      @config = config

      [:api_key, :domain].each do |k|
        raise Railgun::ConfigurationError.new("Config requires `#{k}` key", @config) unless @config.has_key?(k)
      end

      @mg_client = Mailgun::Client.new(config[:api_key], config[:api_host] || 'api.mailgun.net', config[:api_version] || 'v3', config[:api_ssl].nil? ? true : config[:api_ssl])
      @domain = @config[:domain]

      # To avoid exception in mail gem v2.6
      @settings = { return_response: true }

      if (@config[:fake_message_send] || false)
        Rails.logger.info "NOTE: fake message sending has been enabled for mailgun-ruby!"
        @mg_client.enable_test_mode!
      end
    end

    def deliver!(mail)
      mg_message = Railgun.transform_for_mailgun(mail)
      response = @mg_client.send_message(@domain, mg_message)

      if response.code == 200 then
        mg_id = response.to_h['id']
        mail.message_id = mg_id
      end
      response
    end

    def mailgun_client
      @mg_client
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
      message["v:#{k}"] = JSON.dump(v)
    end

    # o:* attributes (options)
    mail.mailgun_options.try(:each) do |k, v|
      message["o:#{k}"] = v
    end

    # support for using ActionMailer's `headers()` inside of the mailer
    # note: this will filter out parameters such as `from`, `to`, and so forth
    #       as they are accepted as POST parameters on the message endpoint.

    msg_headers = Hash.new

    # h:* attributes (headers)
    mail.mailgun_headers.try(:each) do |k, v|
      msg_headers[k] = v
    end

    mail.header_fields.each do |field|
      msg_headers[field.name] = field.value
    end

    msg_headers.each do |k, v|
      if Railgun::Mailer::IGNORED_HEADERS.include? k.downcase
        Rails.logger.debug("[railgun] ignoring header (using envelope instead): #{k}")
        next
      end

      # Cover cases like `cc`, `bcc` where parameters are valid
      # headers BUT they are submitted as separate POST params
      # and already exist on the message because of the call to
      # `build_message_object`.
      if message.include? k.downcase
        Rails.logger.debug("[railgun] ignoring header (already set): #{k}")
        next
      end

      message["h:#{k}"] = v
    end

    # recipient variables
    message['recipient-variables'] = mail.mailgun_recipient_variables.to_json if mail.mailgun_recipient_variables

    # reject blank values
    message.delete_if do |k, v|
      return true if v.nil?

      # if it's an array remove empty elements
      v.delete_if { |i| i.respond_to?(:empty?) && i.empty? } if v.is_a?(Array)

      v.respond_to?(:empty?) && v.empty?
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
      retrieve_html_part(mail).body.decoded || nil
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
      retrieve_text_part(mail).body.decoded || nil
    rescue
      nil
    end
  end

  # Returns the mail object from the Mail::Message object if text part exists,
  # (decomposing multipart into individual format if necessary)
  # otherwise nil.
  #
  # @param [Mail::Message] mail message to transform
  #
  # @return [Mail::Message] mail message with its content-type = text/plain
  def retrieve_text_part(mail)
    return mail.text_part if mail.multipart?
    (mail.mime_type =~ /^text\/plain$/i) && mail
  end

  # Returns the mail object from the Mail::Message object if html part exists,
  # (decomposing multipart into individual format if necessary)
  # otherwise nil.
  #
  # @param [Mail::Message] mail message to transform
  #
  # @return [Mail::Message] mail message with its content-type = text/html
  def retrieve_html_part(mail)
    return mail.html_part if mail.multipart?
    (mail.mime_type =~ /^text\/html$/i) && mail
  end

end
