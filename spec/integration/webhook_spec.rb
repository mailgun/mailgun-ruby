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
