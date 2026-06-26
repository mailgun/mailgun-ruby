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
end
