require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "domains" }

describe 'For the domains endpoint', vcr: vcr_opts do
  let(:api_version) { APIVERSION }
  let(:mg_client) { Mailgun::Client.new(APIKEY, APIHOST, api_version, SSL) }
  let(:mg_obj) { Mailgun::Domains.new(mg_client) }
  let(:domain) { 'integration-test.domain.invalid' }

  context 'Core Domains methods' do
    describe '#list' do
      let(:api_version) { 'v4' }

      it 'returns a list of domains' do
        response = mg_obj.list

        expect(response.size).to be > 0
      end
    end

    describe '#create' do
      let(:api_version) { 'v4' }

      it 'creates a domain' do
        response = mg_obj.create(domain, { spam_action: 'tag' })

        expect(response['domain']['name']).to eq(domain)
        expect(response['domain']['spam_action']).to eq('tag')
      end
    end

    describe '#get' do
      let(:api_version) { 'v4' }

      it 'returns the domain' do
        response = mg_obj.get(domain)

        expect(response).to include('domain')
        expect(response['domain']['name']).to eq(domain)
      end
    end

    context '#update' do
      let(:api_version) { 'v4' }

      it 'updates the domain' do
        response = mg_obj.update(domain, { spam_action: 'block', web_scheme: 'https', wildcard: true })

        expect(response['domain']['spam_action']).to eq('block')
        expect(response['domain']['web_scheme']).to eq('https')
        expect(response['domain']['wildcard']).to eq(true)
      end
    end

    context 'delete a domain' do
      subject(:response) { mg_obj.remove(domain) }

      it { is_expected.to be_falsey }
    end

    # TODO add verify
  end


  context 'Domain::Keys methods' do
    # TODO add missing:
    # - list_domain_keys
    # - create_domain_key
    # - get_domain_keys

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

  context 'Domain::Tracking methods' do
    # TODO add missing:
    # get_domain_tracking_certificate
    # regenerate_domain_tracking_certificate
    # generate_domain_tracking_certificate

    describe '#get_domain_tracking_settings' do
      it 'returns tracking settings for the defined domain' do
        result = mg_obj.get_domain_tracking_settings(
          domain
        )

        expect(result).to include('tracking')
        expect(result['tracking']['click']['active']).to eq(false)
      end
    end

    describe '#update_domain_tracking_click_settings' do
      it 'updates the specified tracking click settings' do
        result = mg_obj.update_domain_tracking_click_settings(
          domain,
          {
            active: false
          }
        )

        expect(result['click']['active']).to eq(false)
      end
    end

    describe '#update_domain_tracking_open_settings' do
      it 'updates the specified tracking open settings' do
        result = mg_obj.update_domain_tracking_open_settings(
          domain,
          {
            active: false
          }
        )

        expect(result['open']['active']).to eq(false)
      end
    end

    describe '#update_domain_tracking_unsubscribe_settings' do
      it 'updates the specified tracking unsubscribe settings' do
        result = mg_obj.update_domain_tracking_unsubscribe_settings(
          domain,
          {
            active: false
          }
        )

        expect(result['unsubscribe']['active']).to eq(false)
      end
    end
  end

  context 'Domain::DKIM_Security methods' do
    # TODO add missing:
    # dkim_rotation
    # dkim_rotate
  end

  context 'Credentials methods' do
    # TODO: to be moved to the dedicated module

    describe '#create_smtp_credentials' do
      it 'creates smtp credentials for domain' do
        result = mg_obj.create_smtp_credentials(
          domain,
          {
            login: 'test_login'
          }
        )

        expect(result['message']).to eq("Created 1 credentials pair(s)")
      end
    end

    describe '#update_smtp_credentials' do
      it 'updates smtp credentials for domain' do
        result = mg_obj.update_smtp_credentials(
          domain,
          'test_login',
          {
            spec: 'abc'
          }
        )

        expect(result['message']).to eq('Password changed')
      end
    end

    describe '#delete_smtp_credentials' do
      it 'deletes smtp credentials for domain' do
        result = mg_obj.delete_smtp_credentials(
          domain,
          'test_login'
        )

        expect(result['message']).to eq('Credentials have been deleted')
      end
    end
  end

  context 'Reporting::Stat methods' do
    # TODO: to be moved to the dedicated module

    describe '#get_domain_stats' do
      it 'returns total stats for a given domain' do
        result = mg_obj.get_domain_stats(
          domain,
          {
            event: 'clicked'
          }
        )

        expect(result).to include('stats')
      end
    end
  end

  def create_mg_object(version)
    mg_client = Mailgun::Client.new(APIKEY, APIHOST, version, SSL)
    Mailgun::Domains.new(mg_client)
  end

  def create_domain
    mg_obj = create_mg_object('v4')
    mg_obj.add_domain(domain)
  end
end
