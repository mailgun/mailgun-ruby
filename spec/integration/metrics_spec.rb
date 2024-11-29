require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'metrics' }

describe Mailgun::Metrics, vcr: vcr_opts do
  let(:metrics) { Mailgun::Metrics.new(Mailgun::Client.new(APIKEY, APIHOST, 'v1')) }

  describe '#account_metrics' do
    let(:options) do
      {
        resolution: 'hour',
        metrics: [
          'accepted_count',
          'delivered_count',
          'clicked_rate',
          'opened_rate'
        ],
        include_aggregates: true,
        start: 'Tue, 26 Nov 2024 20:56:50 -0500',
        duration: '1m',
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
        dimensions: ['time'],
        end: 'Tue, 30 Nov 2024 20:56:50 -0500',
        include_subaccounts: true
      }
    end

    it 'responds with account metrics' do
      expect(metrics.account_metrics(options)).to eq(
        {
          "start" => "Fri, 01 Nov 2024 01:00:00 +0000",
          "end" => "Sun, 01 Dec 2024 01:00:00 +0000",
          "resolution" => "hour",
          "duration" => "1m",
          "dimensions" => ["time"],
          "pagination" => {
            "sort" => "", "skip" => 0, "limit" => 1500, "total" => 3
          },
          "items" => [{
              "dimensions" => [{
                "dimension" => "time",
                "value" => "Wed, 27 Nov 2024 12:00:00 +0000",
                "display_value" => "Wed, 27 Nov 2024 12:00:00 +0000"
              }],
              "metrics" => {
                "accepted_count" => 1, "delivered_count" => 1, "opened_rate" => "0.0000", "clicked_rate" => "0.0000"
              }
            },
            {
              "dimensions" => [{
                "dimension" => "time",
                "value" => "Wed, 27 Nov 2024 13:00:00 +0000",
                "display_value" => "Wed, 27 Nov 2024 13:00:00 +0000"
              }],
              "metrics" => {
                "accepted_count" => 1, "delivered_count" => 1, "opened_rate" => "0.0000", "clicked_rate" => "0.0000"
              }
            },
            {
              "dimensions" => [{
                "dimension" => "time",
                "value" => "Thu, 28 Nov 2024 15:00:00 +0000",
                "display_value" => "Thu, 28 Nov 2024 15:00:00 +0000"
              }],
              "metrics" => {
                "accepted_count" => 1, "delivered_count" => 1, "opened_rate" => "0.0000", "clicked_rate" => "0.0000"
              }
            }
          ],
          "aggregates" => {
            "metrics" => {
              "accepted_count" => 3, "delivered_count" => 3, "opened_rate" => "0.0000", "clicked_rate" => "0.0000"
            }
          }
        }
      )
    end
  end

  describe '#account_usage_metrics' do
    let(:options) do
      {
        resolution: 'hour',
        metrics: [
          'email_preview_count',
          'email_preview_failed_count',
          'email_validation_bulk_count',
          'email_validation_count',
          'email_validation_list_count',
          'email_validation_mailgun_count',
          'email_validation_mailjet_count',
          'email_validation_public_count',
          'email_validation_single_count',
          'email_validation_valid_count',
          'link_validation_count',
          'link_validation_failed_count',
          'processed_count',
          'seed_test_count'
        ],
        include_aggregates: true,
        start: 'Tue, 26 Nov 2024 20:56:50 -0500',
        duration: '1m',
        filter: {
          AND: [
            {
              attribute: 'subaccount',
              comparator: '!=',
              values: [
                {
                  label: '12345',
                  value: '12345'
                }
              ]
            }
          ]
        },
        dimensions: ['time'],
        end: 'Tue, 28 Nov 2024 20:56:50 -0500',
        include_subaccounts: true
      }
    end

    it 'responds with account usage metrics' do
      expect(metrics.account_usage_metrics(options)).to eq(
        {
          "start" => "Tue, 29 Oct 2024 01:00:00 +0000",
          "end" => "Fri, 29 Nov 2024 01:00:00 +0000",
          "resolution" => "hour",
          "duration" => "1m",
          "dimensions" => ["time"],
          "pagination" => {
            "sort" => "", "skip" => 0, "limit" => 1500, "total" => 2
          },
          "items" => [{
              "dimensions" => [{
                "dimension" => "time",
                "value" => "Wed, 27 Nov 2024 00:00:00 +0000",
                "display_value" => "Wed, 27 Nov 2024 00:00:00 +0000"
              }],
              "metrics" => {
                "processed_count" => 2,
                "email_validation_count" => 0,
                "email_validation_public_count" => 0,
                "email_validation_valid_count" => 0,
                "email_validation_single_count" => 0,
                "email_validation_bulk_count" => 0,
                "email_validation_list_count" => 0,
                "email_validation_mailgun_count" => 0,
                "email_validation_mailjet_count" => 0,
                "email_preview_count" => 0,
                "email_preview_failed_count" => 0,
                "link_validation_count" => 0,
                "link_validation_failed_count" => 0,
                "seed_test_count" => 0
              }
            },
            {
              "dimensions" => [{
                "dimension" => "time",
                "value" => "Thu, 28 Nov 2024 00:00:00 +0000",
                "display_value" => "Thu, 28 Nov 2024 00:00:00 +0000"
              }],
              "metrics" => {
                "processed_count" => 1,
                "email_validation_count" => 0,
                "email_validation_public_count" => 0,
                "email_validation_valid_count" => 0,
                "email_validation_single_count" => 0,
                "email_validation_bulk_count" => 0,
                "email_validation_list_count" => 0,
                "email_validation_mailgun_count" => 0,
                "email_validation_mailjet_count" => 0,
                "email_preview_count" => 0,
                "email_preview_failed_count" => 0,
                "link_validation_count" => 0,
                "link_validation_failed_count" => 0,
                "seed_test_count" => 0
              }
            }
          ],
          "aggregates" => {
            "metrics" => {
              "permanent_failed_count" => 0,
              "processed_count" => 3,
              "email_validation_count" => 0,
              "email_validation_public_count" => 0,
              "email_validation_valid_count" => 0,
              "email_validation_single_count" => 0,
              "email_validation_bulk_count" => 0,
              "email_validation_list_count" => 0,
              "email_validation_mailgun_count" => 0,
              "email_validation_mailjet_count" => 0,
              "email_preview_count" => 0,
              "email_preview_failed_count" => 0,
              "link_validation_count" => 0,
              "link_validation_failed_count" => 0,
              "seed_test_count" => 0
            }
          }
        }
      )
    end
  end
end
