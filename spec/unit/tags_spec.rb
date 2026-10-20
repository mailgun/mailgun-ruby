# frozen_string_literal: true

require 'spec_helper'

describe Mailgun::Tags do
  let(:client) { double(:client) }
  let(:tags) { described_class.new(client) }
  let(:response) { instance_double(Mailgun::Response, to_h: {}, to_h!: {}) }

  before { allow(client).to receive_messages(get: response, put: response, delete: response) }

  {
    get_tags: [['example.com'], 'Mailgun::AnalyticsTags#list'],
    get_tag: [%w[example.com newsletter], 'Mailgun::AnalyticsTags#list'],
    update: [%w[example.com newsletter], 'Mailgun::AnalyticsTags#update'],
    remove: [%w[example.com newsletter], 'Mailgun::AnalyticsTags#remove'],
    get_tag_stats: [%w[example.com newsletter], 'Mailgun::Metrics#account_metrics'],
    get_countries_aggregated_stats: [%w[example.com newsletter], 'Mailgun::Metrics#account_metrics'],
    get_providers_aggregated_stats: [%w[example.com newsletter], 'Mailgun::Metrics#account_metrics'],
    get_devices_aggregated_stats: [%w[example.com newsletter], 'Mailgun::Metrics#account_metrics']
  }.each do |method, (args, replacement)|
    describe "##{method}" do
      it "warns that it is deprecated and names #{replacement} as the replacement" do
        message = %("Mailgun::Tags##{method}" is deprecated (Mailgun deprecated the Tags API) ) +
                  %(and will be removed in mailgun-ruby 1.5. Please use "#{replacement}" instead.)

        expect { tags.public_send(method, *args) }.to output(a_string_including(message)).to_stderr
      end
    end
  end
end
