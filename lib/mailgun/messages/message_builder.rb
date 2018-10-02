require 'time'

module Mailgun

  # A Mailgun::MessageBuilder object is used to create a valid payload
  # for the Mailgun API messages endpoint. If you prefer step by step message
  # generation through your code, this class is for you.
  #
  # See the Github documentation for full examples.
  class MessageBuilder

    attr_reader :message, :counters

    # Public: Creates a new MessageBuilder object.
    def initialize
      @message = Hash.new { |hash, key| hash[key] = [] }

      @counters = {
        recipients: { to: 0, cc: 0, bcc: 0 },
        attributes: { attachment: 0, campaign_id: 0, custom_option: 0, tag: 0 }
      }
    end

    # Adds a specific type of recipient to the message object.
    #
    # WARNING: Setting 'h:reply-to' with add_recipient() is deprecated! Use 'reply_to' instead.
    #
    # @param [String] recipient_type The type of recipient. "to", "cc", "bcc" or "h:reply-to".
    # @param [String] address The email address of the recipient to add to the message object.
    # @param [Hash] variables A hash of the variables associated with the recipient. We recommend "first" and "last" at a minimum!
    # @return [void]
    def add_recipient(recipient_type, address, variables = nil)
      if recipient_type == "h:reply-to"
        warn 'DEPRECATION: "add_recipient("h:reply-to", ...)" is deprecated. Please use "reply_to" instead.'
        return reply_to(address, variables)
      end

      if (@counters[:recipients][recipient_type] || 0) >= Mailgun::Chains::MAX_RECIPIENTS
        fail Mailgun::ParameterError, 'Too many recipients added to message.', address
      end

      compiled_address = parse_address(address, variables)
      set_multi_complex(recipient_type, compiled_address)

      @counters[:recipients][recipient_type] += 1 if @counters[:recipients].key?(recipient_type)
    end

    # Sets the from address for the message
    #
    # @param [String] address The address of the sender.
    # @param [Hash] variables A hash of the variables associated with the recipient. We recommend "first" and "last" at a minimum!
    # @return [void]
    def from(address, vars = nil)
      add_recipient(:from, address, vars)
    end

    # Deprecated: please use 'from' instead.
    def set_from_address(address, variables = nil)
      warn 'DEPRECATION: "set_from_address" is deprecated. Please use "from" instead.'
      from(address, variables)
    end

    # Set the message's Reply-To address.
    #
    # Rationale: According to RFC, only one Reply-To address is allowed, so it
    # is *okay* to bypass the set_multi_simple and set reply-to directly.
    #
    # @param [String] address The email address to provide as Reply-To.
    # @param [Hash] variables A hash of variables associated with the recipient.
    # @return [void]
    def reply_to(address, variables = nil)
      compiled_address = parse_address(address, variables)
      header("reply-to", compiled_address)
    end

    # Set a subject for the message object
    #
    # @param [String] subject The subject for the email.
    # @return [void]
    def subject(subj = nil)
      set_multi_simple(:subject, subj)
    end

    # Deprecated: Please use "subject" instead.
    def set_subject(subj = nil)
      warn 'DEPRECATION: "set_subject" is deprecated. Please use "subject" instead.'
      subject(subj)
    end

    # Set a text body for the message object
    #
    # @param [String] text_body The text body for the email.
    # @return [void]
    def body_text(text_body = nil)
      set_multi_simple(:text, text_body)
    end

    # Deprecated: Please use "body_text" instead.
    def set_text_body(text_body = nil)
      warn 'DEPRECATION: "set_text_body" is deprecated. Please use "body_text" instead.'
      body_text(text_body)
    end

    # Set a html body for the message object
    #
    # @param [String] html_body The html body for the email.
    # @return [void]
    def body_html(html_body = nil)
      set_multi_simple(:html, html_body)
    end

    # Deprecated: Please use "body_html" instead.
    def set_html_body(html_body = nil)
      warn 'DEPRECATION: "set_html_body" is deprecated. Please use "body_html" instead.'
      body_html(html_body)
    end

    # Adds a series of attachments, when called upon.
    #
    # @param [String|File] attachment A file object for attaching as an attachment.
    # @param [String] filename The filename you wish the attachment to be.
    # @return [void]
    def add_attachment(attachment, filename = nil)
      add_file(:attachment, attachment, filename)
    end

    # Adds an inline image to the mesage object.
    #
    # @param [String|File] inline_image A file object for attaching an inline image.
    # @param [String] filename The filename you wish the inline image to be.
    # @return [void]
    def add_inline_image(inline_image, filename = nil)
      add_file(:inline, inline_image, filename)
    end

    # Adds a List-Unsubscribe for the message header.
    #
    # @param [Array<String>] *variables Any number of url or mailto
    # @return [void]
    def list_unsubscribe(*variables)
      set_single('h:List-Unsubscribe', variables.map { |var| "<#{var}>" }.join(','))
    end

    # Send a message in test mode. (The message won't really be sent to the recipient)
    #
    # @param [Boolean] mode The boolean or string value (will fix itself)
    # @return [void]
    def test_mode(mode)
      set_multi_simple('o:testmode', bool_lookup(mode))
    end

    # Deprecated: 'set_test_mode' is depreciated. Please use 'test_mode' instead.
    def set_test_mode(mode)
      warn 'DEPRECATION: "set_test_mode" is deprecated. Please use "test_mode" instead.'
      test_mode(mode)
    end

    # Turn DKIM on or off per message
    #
    # @param [Boolean] mode The boolean or string value(will fix itself)
    # @return [void]
    def dkim(mode)
      set_multi_simple('o:dkim', bool_lookup(mode))
    end

    # Deprecated: 'set_dkim' is deprecated. Please use 'dkim' instead.
    def set_dkim(mode)
      warn 'DEPRECATION: "set_dkim" is deprecated. Please use "dkim" instead.'
      dkim(mode)
    end

    # Add campaign IDs to message. Limit of 3 per message.
    #
    # @param [String] campaign_id A defined campaign ID to add to the message.
    # @return [void]
    def add_campaign_id(campaign_id)
      fail(Mailgun::ParameterError, 'Too many campaigns added to message.', campaign_id) if @counters[:attributes][:campaign_id] >= Mailgun::Chains::MAX_CAMPAIGN_IDS

      set_multi_complex('o:campaign', campaign_id)
      @counters[:attributes][:campaign_id] += 1
    end

    # Add tags to message. Limit of 3 per message.
    #
    # @param [String] tag A defined campaign ID to add to the message.
    # @return [void]
    def add_tag(tag)
      if @counters[:attributes][:tag] >= Mailgun::Chains::MAX_TAGS
        fail Mailgun::ParameterError, 'Too many tags added to message.', tag
      end
      set_multi_complex('o:tag', tag)
      @counters[:attributes][:tag] += 1
    end

    # Turn Open Tracking on and off, on a per message basis.
    #
    # @param [Boolean] tracking Boolean true or false.
    # @return [void]
    def track_opens(mode)
      set_multi_simple('o:tracking-opens', bool_lookup(mode))
    end

    # Deprecated: 'set_open_tracking' is deprecated. Please use 'track_opens' instead.
    def set_open_tracking(tracking)
      warn 'DEPRECATION: "set_open_tracking" is deprecated. Please use "track_opens" instead.'
      track_opens(tracking)
    end

    # Turn Click Tracking on and off, on a per message basis.
    #
    # @param [String] mode True, False, or HTML (for HTML only tracking)
    # @return [void]
    def track_clicks(mode)
      set_multi_simple('o:tracking-clicks', bool_lookup(mode))
    end

    # Depreciated: 'set_click_tracking. is deprecated. Please use 'track_clicks' instead.
    def set_click_tracking(tracking)
      warn 'DEPRECATION: "set_click_tracking" is deprecated. Please use "track_clicks" instead.'
      track_clicks(tracking)
    end

    # Enable Delivery delay on message. Specify an RFC2822 date, and Mailgun
    # will not deliver the message until that date/time. For conversion
    # options, see Ruby "Time". Example: "October 25, 2013 10:00PM CST" will
    # be converted to "Fri, 25 Oct 2013 22:00:00 -0600".
    #
    # @param [String] timestamp A date and time, including a timezone.
    # @return [void]
    def deliver_at(timestamp)
      time_str = DateTime.parse(timestamp)
      set_multi_simple('o:deliverytime', time_str.rfc2822)
    end

    # Deprecated: 'set_delivery_time' is deprecated. Please use 'deliver_at' instead.
    def set_delivery_time(timestamp)
      warn 'DEPRECATION: "set_delivery_time" is deprecated. Please use "deliver_at" instead.'
      deliver_at timestamp
    end

    # Add custom data to the message. The data should be either a hash or JSON
    # encoded. The custom data will be added as a header to your message.
    #
    # @param [string] name A name for the custom data. (Ex. X-Mailgun-<Name of Data>: {})
    # @param [Hash] data Either a hash or JSON string.
    # @return [void]
    def header(name, data)
      fail(Mailgun::ParameterError, 'Header name for message must be specified') if name.to_s.empty?
      begin
        jsondata = make_json data
        set_single("h:#{name}", jsondata)
      rescue Mailgun::ParameterError
        set_single("h:#{name}", data)
      end
    end

    # Deprecated: 'set_custom_data' is deprecated. Please use 'header' instead.
    def set_custom_data(name, data)
      warn 'DEPRECATION: "set_custom_data" is deprecated. Please use "header" instead.'
      header name, data
    end

    # Attaches custom JSON data to the message. See the following doc page for more info.
    # https://documentation.mailgun.com/user_manual.html#attaching-data-to-messages
    #
    # @param [String] name A name for the custom variable block.
    # @param [String|Hash] data Either a string or a hash. If it is not valid JSON or
    #                           can not be converted to JSON, ParameterError will be raised.
    # @return [void]
    def variable(name, data)
      fail(Mailgun::ParameterError, 'Variable name must be specified') if name.to_s.empty?
      jsondata = make_json data
      set_single("v:#{name}", jsondata)
    end

    # Add custom parameter to the message. A custom parameter is any parameter that
    # is not yet supported by the SDK, but available at the API. Note: No validation
    # is performed. Don't forget to prefix the parameter with o, h, or v.
    #
    # @param [string] name A name for the custom parameter.
    # @param [string] data A string of data for the parameter.
    # @return [void]
    def add_custom_parameter(name, data)
      set_multi_complex(name, data)
    end

    # Set the Message-Id header to a custom value. Don't forget to enclose the
    # Message-Id in angle brackets, and ensure the @domain is present. Doesn't
    # use simple or complex setters because it should not set value in an array.
    #
    # @param [string] data A string of data for the parameter. Passing nil or
    #   empty string will delete h:Message-Id key and value from @message hash.
    # @return [void]
    def message_id(data = nil)
      key = 'h:Message-Id'
      return @message.delete(key) if data.to_s.empty?
      set_single(key, data)
    end

    # Deprecated: 'set_message_id' is deprecated. Use 'message_id' instead.
    def set_message_id(data = nil)
      warn 'DEPRECATION: "set_message_id" is deprecated. Please use "message_id" instead.'
      message_id data
    end

    private

    # Sets a single value in the message hash where "multidict" features are not needed.
    # Does *not* permit duplicate params.
    #
    # @param [String] parameter The message object parameter name.
    # @param [String] value The value of the parameter.
    # @return [void]
    def set_single(parameter, value)
      @message[parameter] = value ? value : ''
    end

    # Sets values within the multidict, however, prevents
    # duplicate values for keys.
    #
    # @param [String] parameter The message object parameter name.
    # @param [String] value The value of the parameter.
    # @return [void]
    def set_multi_simple(parameter, value)
      @message[parameter] = value ? [value] : ['']
    end

    # Sets values within the multidict, however, allows
    # duplicate values for keys.
    #
    # @param [String] parameter The message object parameter name.
    # @param [String] value The value of the parameter.
    # @return [void]
    def set_multi_complex(parameter, value)
      @message[parameter] << (value || '')
    end

    # Converts boolean type to string
    #
    # @param [String] value The item to convert
    # @return [void]
    def bool_lookup(value)
      return 'yes' if %w(true yes yep).include? value.to_s.downcase
      return 'no' if %w(false no nope).include? value.to_s.downcase
      value
    end

    # Validates whether the input is JSON.
    #
    # @param [String] json_ The suspected JSON string.
    # @return [void]
    def valid_json?(json_)
      JSON.parse(json_)
      return true
    rescue JSON::ParserError
      false
    end

    # Private: given an object attempt to make it into JSON
    #
    # obj - an object. Hopefully a JSON string or Hash
    #
    # Returns a JSON object or raises ParameterError
    def make_json(obj)
      return JSON.parse(obj).to_json if obj.is_a?(String)
      return obj.to_json if obj.is_a?(Hash)
      return JSON.generate(obj).to_json
    rescue
      raise Mailgun::ParameterError, 'Provided data could not be made into JSON. Try a JSON string or Hash.', obj
    end

    # Parses the address and gracefully handles any
    # missing parameters. The result should be something like:
    # "'First Last' <person@domain.com>"
    #
    # @param [String] address The email address to parse.
    # @param [Hash] variables A list of recipient variables.
    # @return [void]
    def parse_address(address, vars)
      return address unless vars.is_a? Hash
      fail(Mailgun::ParameterError, 'Email address not specified') unless address.is_a? String
      if vars['full_name'] != nil && (vars['first'] != nil || vars['last'] != nil)
        fail(Mailgun::ParameterError, 'Must specify at most one of full_name or first/last. Vars passed: #{vars}')
      end

      if vars['full_name']
        full_name = vars['full_name']
      elsif vars['first'] || vars['last']
        full_name = "#{vars['first']} #{vars['last']}".strip
      end 

      return "'#{full_name}' <#{address}>" if defined?(full_name)
      address
    end

    # Private: Adds a file to the message.
    #
    # @param [Symbol] disposition The type of file: :attachment or :inline
    # @param [String|File] attachment A file object for attaching as an attachment.
    # @param [String] filename The filename you wish the attachment to be.
    # @return [void]
    #
    # Returns nothing
    def add_file(disposition, filedata, filename)
      attachment = File.open(filedata, 'r') if filedata.is_a?(String)
      attachment = filedata.dup unless attachment

      fail(Mailgun::ParameterError,
        'Unable to access attachment file object.'
      ) unless attachment.respond_to?(:read)

      unless filename.nil?
        attachment.instance_variable_set :@original_filename, filename
        attachment.instance_eval 'def original_filename; @original_filename; end'
      end
      set_multi_complex(disposition, attachment)
    end
  end

end
