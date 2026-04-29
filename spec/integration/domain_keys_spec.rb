# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'domains' }

describe 'DomainKeys', vcr: vcr_opts do
  let(:api_version) { APIVERSION }
  let(:mg_client) { Mailgun::Client.new(APIKEY, APIHOST, api_version, SSL) }
  let(:mg_obj) { Mailgun::DomainKeys.new(mg_client) }
  let(:domain) { 'integration-test.domain.invalid' }

  describe '#list_domain_keys' do
    let(:api_version) { 'v1' }

    it 'lists all domain keys' do
      result = mg_obj.list_domain_keys(
        {
          signing_domain: domain
        }
      )

      expect(result).to include('items')
      expect(result['items'].first['selector']).to eq('k1')
    end
  end

  describe '#create_domain_key' do
    let(:api_version) { 'v1' }

    it 'creates a domain key' do
      result = mg_obj.create_domain_key(
        {
          signing_domain: domain,
          selector: 'test'
        }
      )

      expect(result['signing_domain']).to eq(domain)
      expect(result['selector']).to eq('test')
    end
  end

  describe '#delete_domain_key' do
    let(:api_version) { 'v1' }

    it 'deletes a domain key' do
      result = mg_obj.delete_domain_key(
        {
          signing_domain: domain,
          selector: 'test'
        }
      )

      expect(result['message']).to eq('success')
    end
  end

  describe '#activate_domain_key' do
    let(:api_version) { 'v4' }

    it 'activates a domain key' do
      result = mg_obj.activate_domain_key(
        domain,
        'mailo1'
      )

      expect(result['message']).to eq('domain key activated')
    end
  end

  describe '#get_domain_keys' do
    let(:api_version) { 'v4' }

    it 'lists the domain keys for a specified signing domain' do
      result = mg_obj.get_domain_keys(
        domain
      )

      expect(result).to include('items')
      expect(result['items'].first['selector']).to eq('mailo1')
    end
  end

  describe '#deactivate_domain_key' do
    let(:api_version) { 'v4' }

    it 'deactivates a domain key' do
      result = mg_obj.deactivate_domain_key(
        domain,
        'tetetet'
      )

      expect(result['message']).to eq('domain key deactivated')
    end
  end

  describe '#update_domain_dkim_authority' do
    it 'updates the DKIM authority for a domain' do
      result = mg_obj.update_domain_dkim_authority(
        domain,
        {
          self: true
        }
      )

      expect(result['message']).to eq('Domain DKIM authority has not been changed')
    end
  end

  describe '#update_domain_dkim_selector' do
    it 'updates the DKIM selector for a domain' do
      result = mg_obj.update_domain_dkim_selector(
        domain,
        {
          dkim_selector: 'mailo1'
        }
      )

      expect(result['message']).to eq('DKIM selector changed')
    end
  end
end
