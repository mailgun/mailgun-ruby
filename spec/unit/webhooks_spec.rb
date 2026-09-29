# frozen_string_literal: true

require 'spec_helper'

describe Mailgun::Webhooks do
  let(:client) { double(:client) }
  let(:webhooks) { described_class.new(client) }
  let(:domain) { 'example.com' }
  let(:url) { 'https://example.com/mailgun/events' }

  %i[create_all add_all_webhooks].each do |method|
    describe "##{method}" do
      it 'creates every webhook action with the provided URL' do
        described_class::ACTIONS.each do |action|
          expect(webhooks).to receive(:create).with(domain, action, url).ordered
        end

        expect { webhooks.public_send(method, domain, url) }
          .to output(/`#{method}` method will be deprecated/).to_stderr
      end
    end
  end

  context 'with v3 endpoints' do
    let(:client) { instance_double(Mailgun::Client, api_version: 'v3') }

    describe '#create' do
      let(:urls) { [url, 'https://example.com/other'] }
      let(:response) do
        instance_double(Mailgun::Response,
                        to_h: { 'message' => 'Webhook has been created', 'webhook' => { 'urls' => urls } })
      end

      before { allow(client).to receive(:post).and_return(response) }

      it 'returns true when a single url was created' do
        expect(webhooks.create(domain, 'delivered', url)).to be(true)
      end

      it 'returns true when multiple urls were created' do
        expect(webhooks.create(domain, 'delivered', urls)).to be(true)
      end

      it 'returns false when a url is missing from the response' do
        expect(webhooks.create(domain, 'delivered', [url, 'https://example.com/missing'])).to be(false)
      end
    end

    describe 'parameter validation' do
      it 'raises a ParameterError when the domain is missing' do
        [nil, ''].each do |blank|
          expect { webhooks.update(blank, 'delivered', url) }
            .to raise_error(Mailgun::ParameterError, 'Domain not provided to update webhooks')
          expect { webhooks.remove(blank, 'delivered') }
            .to raise_error(Mailgun::ParameterError, 'Domain not provided to remove webhook from')
        end
      end

      it 'raises a ParameterError when the action is missing' do
        [nil, ''].each do |blank|
          expect { webhooks.update(domain, blank, url) }
            .to raise_error(Mailgun::ParameterError, 'Action not provided to identify webhook to update')
          expect { webhooks.remove(domain, blank) }
            .to raise_error(Mailgun::ParameterError, 'Action not provided to identify webhook to remove')
        end
      end
    end
  end

  context 'with v4 endpoints' do
    let(:api_version) { 'v4' }
    let(:client) { instance_double(Mailgun::Client, api_version: api_version) }
    let(:response) { instance_double(Mailgun::Response, to_h: { 'webhooks' => { 'accepted' => { 'urls' => [url] } } }) }

    describe '#create_v4' do
      it 'posts the url and event types to the domain webhooks endpoint' do
        expect(client).to receive(:post)
          .with("domains/#{domain}/webhooks", { url: url, event_types: %w[accepted delivered] })
          .and_return(response)

        expect(webhooks.create_v4(domain, url: url, event_types: %w[accepted delivered]))
          .to eq('accepted' => { 'urls' => [url] })
      end
    end

    describe '#update_v4' do
      it 'puts the url and event types to the domain webhooks endpoint' do
        expect(client).to receive(:put)
          .with("domains/#{domain}/webhooks", { url: url, event_types: 'accepted' })
          .and_return(response)

        expect(webhooks.update_v4(domain, url: url, event_types: 'accepted'))
          .to eq('accepted' => { 'urls' => [url] })
      end
    end

    describe '#remove_v4' do
      it 'sends the urls as query params' do
        urls = [url, 'https://example.com/other']
        expect(client).to receive(:delete)
          .with("domains/#{domain}/webhooks", { url: urls })
          .and_return(response)

        webhooks.remove_v4(domain, url: urls)
      end
    end

    context 'when the client api version is not v4' do
      let(:api_version) { 'v3' }

      it 'raises a ParameterError' do
        expect { webhooks.create_v4(domain, url: url, event_types: 'accepted') }
          .to raise_error(Mailgun::ParameterError, /must be v4/)
        expect { webhooks.update_v4(domain, url: url, event_types: 'accepted') }
          .to raise_error(Mailgun::ParameterError, /must be v4/)
        expect { webhooks.remove_v4(domain, url: url) }
          .to raise_error(Mailgun::ParameterError, /must be v4/)
      end
    end
  end
end
