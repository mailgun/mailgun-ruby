# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'logs' }

describe Mailgun::Logs, vcr: vcr_opts do
  let(:logs) { Mailgun::Logs.new(Mailgun::Client.new(APIKEY, APIHOST, 'v1')) }

  describe '#account_logs' do
    let(:options) do
      {
        start: 'Wed, 25 Jun 2025 00:00:00 -0000',
        end: 'Wed, 25 Jun 2025 23:00:00 -0000',
        filter: {
          AND: [
            {
              attribute: 'domain',
              comparator: '!=',
              values: [
                {
                  label: 'example.com',
                  value: 'example.com'
                }
              ]
            }
          ]
        },
        include_subaccounts: true,
        pagination: {
          sort: 'timestamp:asc',
          token: '123',
          limit: 50
        }
      }
    end

    it 'responds with account logs' do
      expect(logs.account_logs(options)).to eq(
        {
          'start' => 'Wed, 25 Jun 2025 00:00:00 -0000',
          'end' => 'Wed, 25 Jun 2025 23:00:00 -0000',
          'items' => [
            {
              'id' => '123',
              'event' => 'accepted',
              '@timestamp' => '2025-06-25T17:19:51.166Z',
              'account' => {
                'id' => '123'
              },
              'method' => 'HTTP',
              'originating-ip' => '123.123.12.123',
              'api-key-id' => 'xxx',
              'domain' => {
                'name' => 'example.mailgun.org'
              },
              'recipient' => 'alex@example.com',
              'recipient-domain' => 'example.com',
              'envelope' => {
                'sender' => 'example.mailgun.org',
                'transport' => 'smtp',
                'targets' => 'alex@example.com'
              },
              'storage' => {
                'region' => 'us-east4',
                'env' => 'production',
                'key' => 'xxx',
                'url' => ['https://storage.api.mailgun.net/v3/domains/example.mailgun.org/messages/123']
              },
              'log-level' => 'info',
              'user-variables' => '{}',
              'message' => {
                'headers' => {
                  'to' => 'alex@example.com',
                  'message-id' => '123@example.mailgun.org',
                  'from' => 'bob@sending_domain.com+4',
                  'subject' => 'The Ruby SDK is awesome!'
                },
                'attachments' => [
                  {
                    'filename' => 'image.jpg',
                    'content-type' => 'image/jpeg',
                    'size' => 16_712
                  }
                ],
                'size' => 23_476
              },
              'flags' => {
                'is-authenticated' => true,
                'is-system-test' => false,
                'is-routed' => false,
                'is-test-mode' => false,
                'is-delayed-bounce' => false,
                'is-callback' => false
              }
            }
          ],
          'pagination' => {},
          'aggregates' => {}
        }
      )
    end
  end
end
