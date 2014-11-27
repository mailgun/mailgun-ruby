require 'time'
require 'json'

module Mailgun

  # A Mailgun::MessageBuilder object is used to create a valid payload
  # for the Mailgun API messages endpoint. If you prefer step by step message
  # generation through your code, this class is for you.
  #
  # See the Github documentation for full examples.
  class MessageBuilder

    attr_reader :message, :counters


    def initialize()
      @message = Hash.new{|hash, key| hash[key] = []}
      @counters = {:recipients  =>
                   {:to  => 0,
                    :cc  => 0,
                    :bcc => 0},
                   :attributes =>
                   {:attachment    => 0,
                    :campaign_id   => 0,
                    :custom_option => 0,
                    :tag           => 0}}
    end


    # Adds a specific type of recipient to the message object.
    #
    # @param [String] recipient_type The type of recipient. "to", "cc", "bcc" or "h:reply-to".
    # @param [String] address The email address of the recipient to add to the message object.
    # @param [Hash] variables A hash of the variables associated with the recipient. We recommend "first" and "last" at a minimum!
    # @return [void]
    def add_recipient(recipient_type, address, variables=nil)
      if (@counters[:recipients][recipient_type] == 1000)
        raise ParameterError.new("Too many recipients added to message.", address)
      end

      compiled_address = parse_address(address, variables)
      complex_setter(recipient_type, compiled_address)

      if @counters[:recipients].has_key?(recipient_type)
        @counters[:recipients][recipient_type] += 1
      end
    end


    # Sets the from address for the message
    #
    # @param [String] address The address of the sender.
    # @param [Hash] variables A hash of the variables associated with the recipient. We recommend "first" and "last" at a minimum!
    # @return [void]
    def set_from_address(address, variables=nil)
      add_recipient(:from, address, variables)
    end


    # Set a subject for the message object
    #
    # @param [String] subject The subject for the email.
    # @return [void]
    def set_subject(subject=nil)
      simple_setter(:subject, subject)
    end


    # Set a text body for the message object
    #
    # @param [String] text_body The text body for the email.
    # @return [void]
    def set_text_body(text_body=nil)
      simple_setter(:text, text_body)
    end


    # Set a html body for the message object
    #
    # @param [String] html_body The html body for the email.
    # @return [void]
    def set_html_body(html_body=nil)
      simple_setter(:html, html_body)
    end


    # Adds a series of attachments, when called upon.
    #
    # @param [String] attachment A file object for attaching as an attachment.
    # @param [String] filename The filename you wish the attachment to be.
    # @return [void]
    def add_attachment(attachment, filename=nil)
      if attachment.is_a?(String)
        attachment = File.open(attachment, "r")
      end
      if !attachment.is_a?(File) || !attachment.respond_to?(:read)
        raise ParameterError.new("Unable to access attachment file object.")
      end
      if !filename.nil?
        attachment.instance_eval "def original_filename; '#{filename}'; end"
      end
      complex_setter(:attachment, attachment)
    end


    # Adds an inline image to the mesage object.
    #
    # @param [String] inline_image A file object for attaching an inline image.
    # @param [String] filename The filename you wish the inline image to be.
    # @return [void]
    def add_inline_image(inline_image, filename=nil)
      if inline_image.is_a?(String)
        inline_image = File.open(inline_image, "r")
      end
      if !inline_image.is_a?(File) || !inline_image.respond_to?(:read)
        raise ParameterError.new("Unable to access attachment file object.")
      end
      if !filename.nil?
        inline_image.instance_eval "def original_filename; '#{filename}'; end"
      end
      complex_setter(:inline, inline_image)
    end


    # Send a message in test mode. (The message won't really be sent to the recipient)
    #
    # @param [Boolean] test_mode The boolean or string value (will fix itself)
    # @return [void]
    def set_test_mode(test_mode)
      simple_setter("o:testmode", bool_lookup(test_mode))
    end


    # Turn DKIM on or off per message
    #
    # @param [Boolean] dkim The boolean or string value(will fix itself)
    # @return [void]
    def set_dkim(dkim)
      simple_setter("o:dkim", bool_lookup(dkim))
    end


    # Add campaign IDs to message. Limit of 3 per message.
    #
    # @param [String] campaign_id A defined campaign ID to add to the message.
    # @return [void]
    def add_campaign_id(campaign_id)
      if (@counters[:attributes][:campaign_id] == 3)
        raise ParameterError.new("Too many campaigns added to message.", campaign_id)
      end
      complex_setter("o:campaign", campaign_id)
      @counters[:attributes][:campaign_id] += 1
    end
    
    
    # Add tags to message. Limit of 3 per message.
    #
    # @param [String] tag A defined campaign ID to add to the message.
    # @return [void]
    def add_tag(tag)
      if (@counters[:attributes][:tag] == 3)
        raise ParameterError.new("Too many tags added to message.", tag)
      end
      complex_setter("o:tag", tag)
      @counters[:attributes][:tag] += 1
    end

    
    # Turn Open Tracking on and off, on a per message basis.
    #
    # @param [Boolean] tracking Boolean true or false.
    # @return [void]
    def set_open_tracking(tracking)
      simple_setter("o:tracking-opens", bool_lookup(tracking))
    end
    
    
    # Turn Click Tracking on and off, on a per message basis.
    #
    # @param [String] tracking True, False, or HTML (for HTML only tracking)
    # @return [void]
    def set_click_tracking(tracking)
      simple_setter("o:tracking-clicks", bool_lookup(tracking))
    end

    
    # Enable Delivery delay on message. Specify an RFC2822 date, and Mailgun
    # will not deliver the message until that date/time. For conversion
    # options, see Ruby "Time". Example: "October 25, 2013 10:00PM CST" will
    # be converted to "Fri, 25 Oct 2013 22:00:00 -0600".
    #
    # @param [String] timestamp A date and time, including a timezone.
    # @return [void]
    def set_delivery_time(timestamp)
      time_str = DateTime.parse(timestamp)
      simple_setter("o:deliverytime", time_str.rfc2822)
    end

    
    # Add custom data to the message. The data should be either a hash or JSON
    # encoded. The custom data will be added as a header to your message.
    #
    # @param [string] name A name for the custom data. (Ex. X-Mailgun-<Name of Data>: {})
    # @param [Hash] data Either a hash or JSON string.
    # @return [void]
    def set_custom_data(name, data)
      if data.is_a?(Hash)
        data = data.to_json
      elsif data.is_a?(String)
        if not valid_json?(data)
          begin
            data = JSON.generate(data)
          rescue
            raise ParameterError.new("Failed to parse provided JSON.", data)
          end
        end
      end
      simple_setter("v:#{name}", data)
    end

    
    # Add custom parameter to the message. A custom parameter is any parameter that
    # is not yet supported by the SDK, but available at the API. Note: No validation
    # is performed. Don't forget to prefix the parameter with o, h, or v.
    #
    # @param [string] name A name for the custom parameter.
    # @param [string] data A string of data for the parameter.
    # @return [void]

    def add_custom_parameter(name, data)
      complex_setter(name, data)
    end
    

    # Set the Message-Id header to a custom value. Don't forget to enclose the
    # Message-Id in angle brackets, and ensure the @domain is present. Doesn't
    # use simple or complex setters because it should not set value in an array.
    #
    # @param [string] data A string of data for the parameter. Passing nil or empty string will delete h:Message-Id key and value from @message hash.
    # @return [void]
    def set_message_id(data)
      key = "h:Message-Id"
      
      if data.to_s.empty?
        @message.delete_if { |k, v| k == key }
      else
        @message[key] = data
      end
    end

    
    private

    # Sets values within the multidict, however, prevents
    # duplicate values for keys.
    #
    # @param [String] parameter The message object parameter name.
    # @param [String] value The value of the parameter.
    # @return [void]
    def simple_setter(parameter, value)
      if value.nil?
        @message[parameter] = ['']
      else
        @message[parameter] = [value]
      end
    end


    # Sets values within the multidict, however, allows
    # duplicate values for keys.
    #
    # @param [String] parameter The message object parameter name.
    # @param [String] value The value of the parameter.
    # @return [void]
    def complex_setter(parameter, value)
      if value.nil?
        @message[parameter] << ''
      else
        @message[parameter] << value
      end
    end

    
    # Converts boolean type to string
    #
    # @param [String] value The item to convert
    # @return [void]
    def bool_lookup(value)
      if value.is_a?(TrueClass) || value.is_a?(FalseClass)
        return value ? "yes" : "no"
      elsif value.is_a?(String)
        value.downcase!
        if ['true', 'yes', 'yep'].include? value
          return "yes"
        elsif ['false', 'no', 'nope'].include? value
          return "no"
        else
          return value
        end
      else
        return value
      end
    end

    # Validates whether the input is JSON.
    #
    # @param [String] json_ The suspected JSON string.
    # @return [void]
    def valid_json? json_
      JSON.parse(json_)
      return true
    rescue JSON::ParserError
      return false
    end

    # Parses the address and gracefully handles any
    # missing parameters. The result should be something like:
    # "'First Last' <person@domain.com>"
    #
    # @param [String] address The email address to parse.
    # @param [Hash] variables A list of recipient variables.
    # @return [void]
    def parse_address(address, variables)
      if variables.nil?
        return address
      end
      first, last = ''
      if variables.has_key?('first')
        first = variables['first']
        if variables.has_key?('last')
          last = variables['last']
        end
        full_name = "#{first} #{last}".strip
      end
      if defined?(full_name)
        return "'#{full_name}' <#{address}>"
      end
      return address
    end

  end

end
