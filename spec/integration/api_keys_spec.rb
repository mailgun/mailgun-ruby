# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'api_keys' }

describe 'ApiKeys', order: :defined, vcr: vcr_opts do
  let(:api_version) { 'v1' }
  let(:mg_client) { Mailgun::Client.new(APIKEY, APIHOST, api_version, SSL) }
  let(:mg_obj) { Mailgun::ApiKeys.new(mg_client) }

  it 'creates an api key' do
    result = mg_obj.create(
      {
        kind: 'user',
        'description': 'test test',
        'role': 'admin'
      }
    )

    expect(result['description']).to eq('test test')
  end

  it 'gets api keys' do
    result = mg_obj.list

    expect(result[0]['id']).to eq('test')
  end

  it 'removes an api key' do
    result = mg_obj.remove('test')

    expect(result).to be_truthy
  end

  it 'regenerates public api key' do
    result = mg_obj.regenerate

    expect(result).to be_truthy
  end
end
