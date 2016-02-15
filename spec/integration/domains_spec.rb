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
end
