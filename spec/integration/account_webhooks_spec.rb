# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'account_webhooks' }

describe 'For the webhooks endpoint', order: :defined, vcr: vcr_opts do
  let(:api_version) { 'v1' }
  let(:mg_client) { Mailgun::Client.new(APIKEY, APIHOST, api_version, SSL) }
  let(:mg_obj) { Mailgun::AccountWebhooks.new(mg_client) }

  it 'creates a webhook' do
    result = mg_obj.create(
      description: 'test',
      event_types: 'accepted',
      url: 'http://example.com/mailgun/events'
    )

    expect(result).to have_key('webhook_id')
  end

  it 'gets a webhook' do
    result = mg_obj.get('test')

    expect(result['url']).to eq('http://example.com/mailgun/events')
  end

  it 'gets a list of all account webhooks' do
    result = mg_obj.list

    expect(result[0]['url']).to eq('http://example.com/mailgun/events')
  end

  it 'updates a webhook' do
    result = mg_obj.update(
      'test',
      description: 'test2',
      event_types: 'accepted',
      url: 'http://example.com/mailgun/events'
    )

    expect(result).to be_truthy
  end

  it 'removes a webhook' do
    result = mg_obj.remove_by_id('test')

    expect(result).to be_truthy
  end

  it 'removes all webhooks' do
    result = mg_obj.remove(all: true)

    expect(result).to be_truthy
  end
end
