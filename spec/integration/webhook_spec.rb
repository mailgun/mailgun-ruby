# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'webhooks' }

describe 'For the webhooks endpoint', order: :defined, vcr: vcr_opts do
  let(:api_version) { 'v3' }
  let(:mg_client) { Mailgun::Client.new(APIKEY, APIHOST, api_version, SSL) }
  let(:mg_obj) { Mailgun::Webhooks.new(mg_client) }
  let(:domain) { 'DOMAIN.TEST' }
  let(:testhook) { 'accepted' }
  let(:testhookup) { 'accepted' }

  it 'creates a webhook' do
    result = mg_obj.create(domain, testhook, "http://example.com/mailgun/events/#{testhook}")

    expect(result).to be_truthy
  end

  it 'gets a webhook' do
    result = mg_obj.get(domain, testhook)

    expect(result).to include("http://example.com/mailgun/events/#{testhook}")
  end

  it 'gets a list of all webhooks' do
    result = mg_obj.list(domain)

    expect(result['accepted']['urls'][0]).to include("http://example.com/mailgun/events/#{testhook}")
  end

  it 'updates a webhook' do
    result = mg_obj.update(domain, testhook, "http://example.com/mailgun/events/#{testhookup}")

    expect(result).to be_truthy
  end

  it 'removes a webhook' do
    result = mg_obj.remove(domain, testhook)

    expect(result).to be_truthy
  end
end

describe 'For the v4 webhooks endpoint', vcr: { cassette_name: 'webhooks_v4' } do
  let(:mg_client) { Mailgun::Client.new(APIKEY, APIHOST, 'v4', SSL) }
  let(:mg_obj) { Mailgun::Webhooks.new(mg_client) }
  let(:domain) { 'DOMAIN.TEST' }
  let(:url) { 'http://example.com/mailgun/events/v4' }

  describe '#create_v4' do
    it 'creates webhooks for multiple event types' do
      result = mg_obj.create_v4(domain, url: url, event_types: %w[accepted delivered])

      expect(result.keys).to contain_exactly('accepted', 'delivered')
      expect(result['accepted']['urls']).to include(url)
      expect(result['delivered']['urls']).to include(url)
    end
  end

  describe '#update_v4' do
    it 'replaces the event types associated with a url' do
      result = mg_obj.update_v4(domain, url: url, event_types: %w[clicked opened])

      expect(result.keys).to contain_exactly('clicked', 'opened')
      expect(result['clicked']['urls']).to include(url)
    end
  end

  describe '#remove_v4' do
    it 'removes the urls from all event types' do
      result = mg_obj.remove_v4(domain, url: [url, 'http://example.com/mailgun/events/v4-other'])

      expect(result).to eq({})
    end
  end
end
