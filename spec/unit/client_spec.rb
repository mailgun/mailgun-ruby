# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'
require 'mailgun/exceptions/exceptions'

describe Mailgun::Client do
  # ---------------------------------------------------------------------------
  # Shared helpers
  # ---------------------------------------------------------------------------
  # Build a client in test mode so no real HTTP calls are ever made.
  subject(:client) { described_class.new(api_key, 'api.mailgun.net', 'v3', true, true) }

  let(:api_key)    { 'test-api-key-abc123' }
  let(:message_params) do
    {
      from: 'bob@example.com',
      to: 'sally@example.com',
      subject: 'Hello!',
      text: 'Test body.'
    }
  end
  let(:domain) { 'example.com' }

  # Fake HTTP response double reusable across examples
  def fake_http_response(body: '{"message":"ok"}', status: 200)
    double('http_response', body: body, status: status)
  end

  # ---------------------------------------------------------------------------
  # .new / #initialize
  # ---------------------------------------------------------------------------
  describe '#initialize' do
    it 'instantiates without raising' do
      expect { described_class.new(api_key) }.not_to raise_error
    end

    it 'stores the api_version' do
      c = described_class.new(api_key, 'api.mailgun.net', 'v3')
      expect(c.api_version).to eq('v3')
    end

    it 'defaults test_mode to false when not specified' do
      # Pass test_mode = false explicitly to avoid picking up global config
      c = described_class.new(api_key, 'api.mailgun.net', 'v3', true, false)
      expect(c.test_mode?).to be(false)
    end

    it 'accepts test_mode = true' do
      c = described_class.new(api_key, 'api.mailgun.net', nil, true, true)
      expect(c.test_mode?).to be(true)
    end

    it 'supports EU api host' do
      expect { described_class.new(api_key, 'api.eu.mailgun.net') }.not_to raise_error
    end
  end

  # ---------------------------------------------------------------------------
  # #test_mode?
  # ---------------------------------------------------------------------------
  describe '#test_mode?' do
    it 'returns true when the client is in test mode' do
      expect(client.test_mode?).to be(true)
    end

    it 'returns false when test mode has been disabled' do
      client.disable_test_mode!
      expect(client.test_mode?).to be(false)
    end
  end

  # ---------------------------------------------------------------------------
  # #enable_test_mode!
  # ---------------------------------------------------------------------------
  describe '#enable_test_mode!' do
    subject(:non_test_client) do
      described_class.new(api_key, 'api.mailgun.net', 'v3', true, false)
    end

    it 'sets test_mode to true' do
      non_test_client.enable_test_mode!
      expect(non_test_client.test_mode?).to be(true)
    end
  end

  # ---------------------------------------------------------------------------
  # #disable_test_mode!
  # ---------------------------------------------------------------------------
  describe '#disable_test_mode!' do
    it 'sets test_mode to false' do
      client.disable_test_mode!
      expect(client.test_mode?).to be(false)
    end
  end

  # ---------------------------------------------------------------------------
  # .deliveries
  # ---------------------------------------------------------------------------
  describe '.deliveries' do
    before { described_class.deliveries.clear }

    it 'returns an Array' do
      expect(described_class.deliveries).to be_an(Array)
    end

    it 'accumulates messages sent in test mode' do
      client.send_message(domain, message_params)
      expect(described_class.deliveries).not_to be_empty
    end

    it 'stores the message data sent in test mode' do
      client.send_message(domain, message_params)
      expect(described_class.deliveries.last).to include(from: 'bob@example.com')
    end

    it 'accumulates multiple deliveries' do
      2.times { client.send_message(domain, message_params) }
      expect(described_class.deliveries.size).to eq(2)
    end
  end

  # ---------------------------------------------------------------------------
  # #send_message — test mode
  # ---------------------------------------------------------------------------
  describe '#send_message (test mode)' do
    before { described_class.deliveries.clear }

    it 'returns a Mailgun::Response' do
      result = client.send_message(domain, message_params)
      expect(result).to be_a(Mailgun::Response)
    end

    it 'returns a 200 status response in test mode' do
      result = client.send_message(domain, message_params)
      expect(result.code).to eq(200)
    end

    it 'returns a body containing the Queued message in test mode' do
      result = client.send_message(domain, message_params)
      body = JSON.parse(result.body)
      expect(body['message']).to eq('Queued. Thank you.')
    end

    it 'returns a body with a unique test-mode message id' do
      result = client.send_message(domain, message_params)
      body = JSON.parse(result.body)
      expect(body['id']).to match(/test-mode-mail-.+@localhost/)
    end

    it 'does not make real HTTP calls in test mode' do
      expect(client.instance_variable_get(:@http_client)).not_to receive(:post)
      client.send_message(domain, message_params)
    end

    it 'records a copy of message data in .deliveries' do
      client.send_message(domain, message_params)
      expect(described_class.deliveries.last[:subject]).to eq('Hello!')
    end

    context 'with a MessageBuilder object' do
      it 'stores the MessageBuilder in .deliveries' do
        mb = Mailgun::MessageBuilder.new
        mb.set_from_address('bob@example.com')
        mb.add_recipient(:to, 'sally@example.com')
        mb.set_subject('Hello via builder!')
        mb.set_text_body('Body text.')

        result = client.send_message(domain, mb)
        expect(result).to be_a(Mailgun::Response)
        expect(described_class.deliveries.last).to be_a(Mailgun::MessageBuilder)
      end

      it 'raises a Mailgun::ParameterError when mb is empty' do
        mb = Mailgun::MessageBuilder.new

        expect { client.send_message(domain, mb) }
          .to raise_error(Mailgun::ParameterError)
      end

      it 'raises a Mailgun::ParameterError when from is missing' do
        mb = Mailgun::MessageBuilder.new
        mb.add_recipient(:to, 'sally@example.com')

        expect { client.send_message(domain, mb) }
          .to raise_error(Mailgun::ParameterError)
      end
    end
  end

  # ---------------------------------------------------------------------------
  # #send_message — live mode (HTTP mocked at the Faraday level)
  # ---------------------------------------------------------------------------
  describe '#send_message (live mode)' do
    subject(:live_client) do
      described_class.new(api_key, 'api.mailgun.net', 'v3', true, false)
    end

    let(:success_response) { fake_http_response }

    before do
      allow(live_client.instance_variable_get(:@http_client))
        .to receive(:post)
        .and_return(success_response)
    end

    it 'posts to the messages endpoint and returns a Response' do
      result = live_client.send_message(domain, message_params)
      expect(result).to be_a(Mailgun::Response)
    end

    it 'strips nil values from the data hash before posting' do
      params_with_nil = message_params.merge(cc: nil)
      http = live_client.instance_variable_get(:@http_client)
      expect(http).to receive(:post) do |_path, data, *|
        expect(data).not_to have_key(:cc)
        success_response
      end
      live_client.send_message(domain, params_with_nil)
    end

    it 'raises CommunicationError when the underlying request fails' do
      allow(live_client.instance_variable_get(:@http_client))
        .to receive(:post)
        .and_raise(StandardError, 'connection refused')

      expect { live_client.send_message(domain, message_params) }
        .to raise_error(Mailgun::CommunicationError)
    end

    context 'with a MessageBuilder object' do
      it 'posts to the messages endpoint and returns a Response' do
        mb = Mailgun::MessageBuilder.new
        mb.set_from_address('bob@example.com')
        mb.add_recipient(:to, 'sally@example.com')
        mb.set_subject('Hello via builder!')
        mb.set_text_body('Body text.')

        result = live_client.send_message(domain, mb)
        expect(result).to be_a(Mailgun::Response)
      end
    end
  end

  # ---------------------------------------------------------------------------
  # #get
  # ---------------------------------------------------------------------------
  describe '#get' do
    let(:http_response) { fake_http_response }

    before do
      allow(client.instance_variable_get(:@http_client))
        .to receive(:get)
        .and_return(http_response)
    end

    it 'returns a Mailgun::Response' do
      result = client.get("#{domain}/events", { event: 'delivered' })
      expect(result).to be_a(Mailgun::Response)
    end

    it 'passes the resource path through to the http client' do
      http = client.instance_variable_get(:@http_client)
      expect(http).to receive(:get).with("#{domain}/events", anything, anything)
                                   .and_return(http_response)
      client.get("#{domain}/events")
    end

    it 'raises CommunicationError on failure' do
      allow(client.instance_variable_get(:@http_client))
        .to receive(:get)
        .and_raise(StandardError, 'timeout')

      expect { client.get("#{domain}/events") }
        .to raise_error(Mailgun::CommunicationError)
    end
  end

  # ---------------------------------------------------------------------------
  # #post
  # ---------------------------------------------------------------------------
  describe '#post' do
    let(:http_response) { fake_http_response }

    before do
      allow(client.instance_variable_get(:@http_client))
        .to receive(:post)
        .and_return(http_response)
    end

    it 'returns a Mailgun::Response' do
      result = client.post("#{domain}/messages", message_params)
      expect(result).to be_a(Mailgun::Response)
    end

    it 'raises CommunicationError on failure' do
      allow(client.instance_variable_get(:@http_client))
        .to receive(:post)
        .and_raise(StandardError, 'connection error')

      expect { client.post("#{domain}/messages", message_params) }
        .to raise_error(Mailgun::CommunicationError)
    end
  end

  # ---------------------------------------------------------------------------
  # #put
  # ---------------------------------------------------------------------------
  describe '#put' do
    let(:http_response) { fake_http_response }

    before do
      allow(client.instance_variable_get(:@http_client))
        .to receive(:put)
        .and_return(http_response)
    end

    it 'returns a Mailgun::Response' do
      result = client.put("#{domain}/routes/abc123", { description: 'updated' })
      expect(result).to be_a(Mailgun::Response)
    end

    it 'raises CommunicationError on failure' do
      allow(client.instance_variable_get(:@http_client))
        .to receive(:put)
        .and_raise(StandardError, 'connection error')

      expect { client.put("#{domain}/routes/abc123", {}) }
        .to raise_error(Mailgun::CommunicationError)
    end
  end

  # ---------------------------------------------------------------------------
  # #delete
  # ---------------------------------------------------------------------------
  describe '#delete' do
    let(:http_response) { fake_http_response(body: '{"message":"Bounced address has been removed"}') }

    before do
      allow(client.instance_variable_get(:@http_client))
        .to receive(:delete)
        .and_return(http_response)
    end

    it 'returns a Mailgun::Response' do
      result = client.delete("#{domain}/bounces/test@example.com")
      expect(result).to be_a(Mailgun::Response)
    end

    it 'raises CommunicationError on failure' do
      allow(client.instance_variable_get(:@http_client))
        .to receive(:delete)
        .and_raise(StandardError, 'connection error')

      expect { client.delete("#{domain}/bounces/test@example.com") }
        .to raise_error(Mailgun::CommunicationError)
    end

    it 'sends params in the request' do
      result = client.delete("#{domain}/bounces/test@example.com", params: 'test')
      expect(result).to be_a(Mailgun::Response)
    end

    it 'sends params in the request when body_params truthy' do
      result = client.delete("#{domain}/bounces/test@example.com", params: 'test', body_params: true)
      expect(result).to be_a(Mailgun::Response)
    end
  end

  # ---------------------------------------------------------------------------
  # #set_api_key
  # ---------------------------------------------------------------------------
  describe '#set_api_key' do
    it 'does not raise when updating the api key' do
      expect { client.set_api_key('new-key-xyz') }.not_to raise_error
    end
  end

  # ---------------------------------------------------------------------------
  # #set_subaccount / #reset_subaccount
  # ---------------------------------------------------------------------------
  describe '#set_subaccount' do
    it 'adds the subaccount header to the http client' do
      client.set_subaccount('subaccount-id-123')
      headers = client.instance_variable_get(:@http_client).headers
      expect(headers[Mailgun::Client::SUBACCOUNT_HEADER]).to eq('subaccount-id-123')
    end
  end

  describe '#reset_subaccount' do
    it 'removes the subaccount header from the http client' do
      client.set_subaccount('subaccount-id-123')
      client.reset_subaccount
      headers = client.instance_variable_get(:@http_client).headers
      expect(headers[Mailgun::Client::SUBACCOUNT_HEADER]).to be_nil
    end
  end

  # ---------------------------------------------------------------------------
  # #suppressions
  # ---------------------------------------------------------------------------
  describe '#suppressions' do
    it 'returns a Mailgun::Suppressions instance' do
      expect(client.suppressions(domain)).to be_a(Mailgun::Suppressions)
    end

    it 'scopes the suppressions client to the given domain' do
      suppressions = client.suppressions(domain)
      expect(suppressions).to be_a(Mailgun::Suppressions)
    end
  end

  # ---------------------------------------------------------------------------
  # Mailgun.configure integration
  # ---------------------------------------------------------------------------
  describe 'Mailgun.configure integration' do
    after { Mailgun.instance_variable_set(:@configuration, nil) }

    it 'picks up the api_key from Mailgun.configure' do
      Mailgun.configure { |config| config.api_key = 'configured-key' }
      expect { described_class.new }.not_to raise_error
    end
  end
end
