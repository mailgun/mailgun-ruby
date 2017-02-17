require 'mailgun/messages/message_builder'

module Mailgun

  # A Mailgun::BatchMessage object is used to create a valid payload
  # for Batch Sending. Batch Sending can be difficult to implement, therefore
  # this code makes it dead simple to send millions of messages in batches of
  # 1,000 recipients per HTTP call.
  #
  # For the curious, the class simply keeps track of recipient data (count,
  # user variables), and fires the API payload on the 1,000th addition of a recipient.
  #
  # The best way to use this class is:
  # 1. Build your message using the Message Builder methods.
  # 2. Query your source and create an iterable list.
  # 3. Iterate through your source data, and add your recipients using the
  #    add_recipient() method.
  # 4. Call finalize() to flush any remaining recipients and obtain/store
  #    the message_ids for tracking purposes.
  #
  # See the Github documentation for full examples.
  class BatchMessage < MessageBuilder

    attr_reader :message_ids, :domain, :recipient_variables

    # Public: Creates a new BatchMessage object.
    def initialize(client, domain)
      @client = client
      @recipient_variables = {}
      @domain = domain
      @message_ids = {}
      @message = Hash.new { |hash, key| hash[key] = [] }

      @counters = {
        recipients: { to: 0, cc: 0, bcc: 0 },
        attributes: { attachment: 0, campaign_id: 0, custom_option: 0, tag: 0 }
      }
    end

    # Adds a specific type of recipient to the batch message object.
    #
    # @param [String] recipient_type The type of recipient. "to".
    # @param [String] address The email address of the recipient to add to the message object.
    # @param [Hash] variables A hash of the variables associated with the recipient. We recommend "first" and "last" at a minimum!
    # @return [void]
    def add_recipient(recipient_type, address, variables = nil)
      # send the message when we have 1000, not before
      send_message if @counters[:recipients][recipient_type] == Mailgun::Chains::MAX_RECIPIENTS

      compiled_address = parse_address(address, variables)
      set_multi_complex(recipient_type, compiled_address)

      store_recipient_variables(recipient_type, address, variables) if recipient_type != :from

      @counters[:recipients][recipient_type] += 1 if @counters[:recipients].key?(recipient_type)
    end

    # Always call this function after adding recipients. If less than 1000 are added,
    # this function will ensure the batch is sent.
    #
    # @return [Hash] A hash of {'Message ID' => '# of Messages Sent'}
    def finalize
      send_message if any_recipients_left?
      @message_ids
    end

    private

    # This method determines if it's necessary to send another batch.
    #
    # @return [Boolean]
    def any_recipients_left?
      return true if @counters[:recipients][:to] > 0
      return true if @counters[:recipients][:cc] > 0
      return true if @counters[:recipients][:bcc] > 0
      false
    end

    # This method initiates a batch send to the API. It formats the recipient
    # variables, posts to the API, gathers the message IDs, then flushes that data
    # to prepare for the next batch. This method implements the Mailgun Client, thus,
    # an exception will be thrown if a communication error occurs.
    #
    # @return [Boolean]
    def send_message
      rkey = 'recipient-variables'
      set_multi_simple rkey, JSON.generate(@recipient_variables)
      @message[rkey] = @message[rkey].first if @message.key?(rkey)

      response = @client.send_message(@domain, @message).to_h!
      message_id = response['id'].gsub(/\>|\</, '')
      @message_ids[message_id] = count_recipients
      reset_message
    end

    # This method stores recipient variables for each recipient added, if
    # variables exist.
    def store_recipient_variables(recipient_type, address, variables)
      variables = { id: @counters[:recipients][recipient_type] } unless variables
      @recipient_variables[address] = variables
    end

    # This method stores recipient variables for each recipient added, if
    # variables exist.
    def count_recipients
      count = 0
      @counters[:recipients].each_value { |cnt| count += cnt }
      count
    end

    # This method resets the message object to prepare for the next batch
    # of recipients.
    def reset_message
      @message.delete('recipient-variables')
      @message.delete(:to)
      @message.delete(:cc)
      @message.delete(:bcc)
      @counters[:recipients][:to] = 0
      @counters[:recipients][:cc] = 0
      @counters[:recipients][:bcc] = 0
    end

  end

end
