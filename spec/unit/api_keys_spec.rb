# frozen_string_literal: true

require 'spec_helper'

describe Mailgun::ApiKeys do
  let(:client) { instance_double(Mailgun::Client, api_version: 'v1') }
  let(:api_keys) { described_class.new(client) }
  let(:response) { instance_double(Mailgun::Response, to_h: { 'items' => [{ 'id' => 'test' }] }) }

  describe '#list' do
    it 'lists all keys when no filters are given' do
      expect(client).to receive(:get).with('keys', {}).and_return(response)

      expect(api_keys.list).to eq([{ 'id' => 'test' }])
    end

    it 'passes the domain_name and kind filters as query params' do
      expect(client).to receive(:get)
        .with('keys', { domain_name: 'example.com', kind: 'domain' })
        .and_return(response)

      api_keys.list(domain_name: 'example.com', kind: 'domain')
    end
  end
end
