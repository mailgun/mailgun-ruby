require 'time'
require 'json'

module Mailgun
  class UnitClient < Mailgun::Client
    attr_reader :options, :block, :body, :code, :response

    def initialize(endpoint, &block)
      @block = block
      @endpoint = endpoint
      @body = nil
      @code = nil
    end

    def [](endpoint, &new_block)
      if block_given?
        self.class.new(endpoint, &new_block)
      elsif block
        self.class.new(endpoint, &block)
      else
        self.class.new(endpoint)
      end
    end

    def send_message(working_domain, data)
      perform_data_validation(working_domain, data)
      case data
      when Hash
        if data.has_key?(:message)
          data[:message] = convert_string_to_file(data[:message]) if data[:message].is_a?(String)
          post("#{working_domain}/messages.mime", data)
        else
          post("#{working_domain}/messages", data)
        end
      when MessageBuilder
        post("#{working_domain}/messages", data.message)
      else
        raise ParameterError.new('Unknown data type for data parameter.', data)
      end
    end

    def post(_path, _data)
      Mailgun::Response.new(response_generator(@endpoint))
    rescue StandardError => e
      p e
      raise CommunicationError.new(e), e.response if e.respond_to? :response

      raise CommunicationError.new(e.message)
    end

    def get(_path, _query_string = nil)
      Mailgun::Response.new(response_generator(@endpoint))
    rescue StandardError => e
      raise CommunicationError.new(e), e.response
    end

    def put(_path, _data)
      Mailgun::Response.new(response_generator(@endpoint))
    rescue StandardError => e
      raise CommunicationError.new(e), e.response
    end

    def delete(_path)
      Mailgun::Response.new(response_generator(@endpoint))
    rescue StandardError => e
      raise CommunicationError.new(e), e.response
    end

    private

    def perform_data_validation(working_domain, data)
      raise ParameterError.new('Missing working domain', working_domain) unless working_domain
      return true unless data.is_a?(Hash) && data.present?

      message = data.respond_to?(:message) ? data.message : data

      if message.fetch('to', []).empty? && message.fetch(:to, []).empty?
        raise ParameterError.new(
          'Missing `to` recipient, message should contain at least 1 recipient',
          working_domain
        )
      end
      return unless message.fetch('from', []).empty? && message.fetch(:from, []).empty?

      raise ParameterError.new(
        'Missing a `from` sender, message should contain at least 1 `from` sender',
        working_domain
      )
    end

    def response_generator(resource_endpoint)
      if resource_endpoint == 'messages'
        t = Time.now
        id = "<#{t.to_i}.#{rand(99_999_999)}.5817@example.com>"
        return Response.from_hash({ body: JSON.generate({ 'message' => 'Queued. Thank you.', 'id' => id }) })
      end
      if resource_endpoint == 'bounces'
        return Response.from_hash({ body: JSON.generate({ 'total_count' => 1,
                                                          'items' => { 'created_at' => 'Fri, 21 Oct 2011 11:02:55 GMT', 'status' => 550, 'address' => 'baz@example.com',
                                                                       'error' => 'Message was not accepted -- invalid mailbox. Local mailbox baz@example.com is unavailable: user not found' } }) })
      end
      if resource_endpoint == 'lists'
        return Response.from_hash({ body: JSON.generate({
                                                          'member' => { 'vars' => { 'age' => 26 }, 'name' => 'Foo Bar', 'subscribed' => false,
                                                                        'address' => 'bar@example.com' }, 'message' => 'Mailing list member has been updated'
                                                        }) })
      end
      if resource_endpoint == 'campaigns'
        return Response.from_hash({ body: JSON.generate({ 'message' => 'Campaign has been deleted',
                                                          'id' => 'ABC123' }) })
      end
      return unless resource_endpoint == 'events'

      Response.from_hash({ body: JSON.generate({ 'items' => [],
                                                 'paging' => {
                                                   'next' => 'https://api.mailgun.net/v3/thisisatestdomainformailgun.com/events/W3siYiI6ICIyMDE0LTA1LTA3VDAwOjQ1OjUxLjc0MDg5MiswMDowMCIsICJlIjogIjIwMTQtMDUtMDVUMDA6NDU6NTEuNzQwOTgzKzAwOjAwIn0sIHsiYiI6ICIyMDE0LTA1LTA3VDAwOjQ1OjUxLjc0MDg5MiswMDowMCIsICJlIjogIjIwMTQtMDUtMDVUMDA6NDU6NTEuNzQwOTgzKzAwOjAwIn0sIFsiZiJdLCBudWxsLCB7ImFjY291bnQuaWQiOiAiNGU4MjMwZjYxNDc2ZDg2NzEzMDBjNDc2IiwgImRvbWFpbi5uYW1lIjogInRoaXNpc2F0ZXN0ZG9tYWluZm9ybWFpbGd1bi5jb20iLCAic2V2ZXJpdHkiOiAiTk9UIGludGVybmFsIn0sIDEwMCwgbnVsbF0=', 'previous' => 'https://api.mailgun.net/v2/thisisatestdomainformailgun.com/events/W3siYiI6ICIyMDE0LTA1LTA3VDAwOjQ1OjUxLjc0MDg5MiswMDowMCIsICJlIjogIjIwMTQtMDUtMDVUMDA6NDU6NTEuNzQwOTgzKzAwOjAwIn0sIHsiYiI6ICIyMDE0LTA1LTA3VDAwOjQ1OjUxLjc0MDg5MiswMDowMCIsICJlIjogIjIwMTQtMDUtMDdUMDA6NDU6NTEuNzQxODkyKzAwOjAwIn0sIFsicCIsICJmIl0sIG51bGwsIHsiYWNjb3VudC5pZCI6ICI0ZTgyMzBmNjE0NzZkODY3MTMwMGM0NzYiLCAiZG9tYWluLm5hbWUiOiAidGhpc2lzYXRlc3Rkb21haW5mb3JtYWlsZ3VuLmNvbSIsICJzZXZlcml0eSI6ICJOT1QgaW50ZXJuYWwifSwgMTAwLCBudWxsXQ=='
                                                 } }) })
    end
  end
end
