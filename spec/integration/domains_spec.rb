require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "domains" }

describe 'For the domains endpoint', vcr: vcr_opts do
  before(:all) do
    @mg_client = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @mg_obj = Mailgun::Domains.new(@mg_client)
    @domain = "integration-test.domain.invalid"
  end

  it 'creates the domain' do
    result = @mg_obj.add_domain(@domain, { smtp_password: 'super_secret', spam_action: 'tag' })

    expect(result['domain']["name"]).to eq(@domain)
    expect(result['domain']["spam_action"]).to eq("tag")
    expect(result['domain']["smtp_password"]).to eq("super_secret")
  end

  it 'get the domain.' do
    result = @mg_obj.get(@domain)

    expect(result).to include("domain")
    expect(result["domain"]["name"]).to eq(@domain)
  end

  it 'gets a list of domains.' do
    result = @mg_obj.get_domains

    expect(result.size).to be > 0
  end

  it 'deletes a domain.' do
    result = @mg_obj.delete(@domain)

    expect(result).to be_truthy
  end

  it 'updates the domain' do
    result = @mg_obj.update(@domain, { spam_action: 'block', web_scheme: 'https', wildcard: true })

    expect(result['domain']["spam_action"]).to eq('block')
    expect(result['domain']["web_scheme"]).to eq('https')
    expect(result['domain']["wildcard"]).to eq(true)
  end

  describe '#create_smtp_credentials' do
    it 'creates smtp credentials for domain' do
      result = @mg_obj.create_smtp_credentials(
        @domain,
        {
          login: 'test_login',
          password: 'test_password'
        }
      )

      expect(result['message']).to eq("Created 1 credentials pair(s)")
    end
  end

  describe '#update_smtp_credentials' do
    it 'updates smtp credentials for domain' do
      result = @mg_obj.update_smtp_credentials(
        @domain,
        'test_login',
        {
          password: 'test_password2'
        }
      )

      expect(result['message']).to eq('Password changed')
    end
  end

  describe '#delete_smtp_credentials' do
    it 'deletes smtp credentials for domain' do
      result = @mg_obj.delete_smtp_credentials(
        @domain,
        'test_login'
      )

      expect(result['message']).to eq('Credentials have been deleted')
    end
  end

  describe '#delete_smtp_credentials' do
    it 'deletes smtp credentials for domain' do
      result = @mg_obj.delete_smtp_credentials(
        @domain,
        'test_login'
      )

      expect(result['message']).to eq('Credentials have been deleted')
    end
  end

  describe '#get_domain_connection_settings' do
    it 'returns delivery connection settings for the defined domain' do
      result = @mg_obj.get_domain_connection_settings(
        @domain
      )

      expect(result).to include(
        'require_tls' => false,
        'skip_verification' => false
      )
    end
  end

  describe '#update_domain_connection_settings' do
    it 'updates the specified delivery connection settings' do
      result = @mg_obj.update_domain_connection_settings(
        @domain,
        {
          require_tls: true,
          skip_verification: true
        }
      )

      expect(result).to include(
        'require_tls' => true,
        'skip_verification' => true
      )
    end
  end

  describe '#get_domain_tracking_settings' do
    it 'returns tracking settings for the defined domain' do
      result = @mg_obj.get_domain_tracking_settings(
        @domain
      )

      expect(result).to include('tracking')
      expect(result['tracking']['click']['active']).to eq(true)
    end
  end

  describe '#update_domain_tracking_open_settings' do
    it 'updates the specified tracking open settings' do
      result = @mg_obj.update_domain_tracking_open_settings(
        @domain,
        {
          active: false
        }
      )

      expect(result['open']['active']).to eq(false)
    end
  end

  describe '#update_domain_tracking_click_settings' do
    it 'updates the specified tracking click settings' do
      result = @mg_obj.update_domain_tracking_click_settings(
        @domain,
        {
          active: false
        }
      )

      expect(result['click']['active']).to eq(false)
    end
  end

  describe '#update_domain_tracking_unsubscribe_settings' do
    it 'updates the specified tracking unsubscribe settings' do
      result = @mg_obj.update_domain_tracking_unsubscribe_settings(
        @domain,
        {
          active: false
        }
      )

      expect(result['unsubscribe']['active']).to eq(false)
    end
  end

  describe '#update_domain_dkim_authority' do
    it 'updates the DKIM authority for a domain' do
      result = @mg_obj.update_domain_dkim_authority(
        @domain,
        {
          active: false
        }
      )

      expect(result['message']).to eq('Domain DKIM authority has been changed')
    end
  end

  describe '#update_domain_dkim_selector' do
    it 'updates the DKIM selector for a domain' do
      result = @mg_obj.update_domain_dkim_selector(
        @domain,
        {
          dkim_selector: 'mailo1'
        }
      )

      expect(result['message']).to eq('Domain DKIM authority changed')
    end
  end

  describe '#update_domain_web_prefix' do
    it 'updates the the CNAME used for tracking opens and clicks' do
      result = @mg_obj.update_domain_web_prefix(
        @domain,
        {
          web_prefix: 'email'
        }
      )

      expect(result['message']).to eq('Domain web prefix updated')
    end
  end

  describe 'V4' do
    before do
      @mg_client = Mailgun::Client.new(APIKEY, APIHOST, 'v4', SSL)
      @mg_obj = Mailgun::Domains.new(@mg_client)
    end

    describe '#get_domain_keys' do
      it 'lists the domain keys for a specified signing domain' do
        result = @mg_obj.get_domain_keys(
          @domain
        )

        expect(result).to include('items')
        expect(result['items'].first['selector']).to eq('mailo1')
      end
    end

    describe '#activate_domain_key' do
      it 'activates a domain key' do
        result = @mg_obj.activate_domain_key(
          @domain,
          'smtp'
        )

       expect(result['message']).to eq('domain key activated')
      end
    end

    describe '#deactivate_domain_key' do
      it 'deactivates a domain key' do
        result = @mg_obj.deactivate_domain_key(
          {
            signing_domain: 'x509.zeefarmer.com',
            selector: 'tetetet'
          }
        )

       expect(result['message']).to eq('domain key deactivated')
      end
    end
  end

  describe '#delete_domain_key' do
    before do
      @mg_client = Mailgun::Client.new(APIKEY, APIHOST, 'v1', SSL)
      @mg_obj = Mailgun::Domains.new(@mg_client)
    end

    it 'deletes a domain key' do
      result = @mg_obj.delete_domain_key(
        {
          signing_domain: @domain,
          selector: 'test'
        }
      )

     expect(result['message']).to eq('success')
    end
  end

  describe '#get_domain_stats' do
    it 'returns total stats for a given domain' do
      result = @mg_obj.get_domain_stats(
        @domain,
        {
          event: 'clicked',
          start: 'Sun, 23 Dec 2023 01:23:45 JST',
          duration: '24h'
        }
      )

     expect(result).to include('stats')
    end
  end
end
