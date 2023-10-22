require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "campaigns" }

describe 'For the campaigns endpoint', vcr: vcr_opts do
  before(:all) do
    skip 'pending removal'
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN
    @campaign_id = "integration_test_campaign"
  end

  it 'creates a campaign' do
    result = @mg_obj.post("#{@domain}/campaigns", {:name => 'My Campaign',
                                                   :id => @campaign_id})

    result.to_h!
    expect(result.body["message"]).to eq("Campaign created")
    expect(result.body["campaign"]["id"]).to eq(@campaign_id)
    expect(result.body["campaign"]["name"]).to eq('My Campaign')
  end

  it 'get a campaign.' do
    result = @mg_obj.get("#{@domain}/campaigns/#{@campaign_id}")

    result.to_h!
    expect(result.body["id"]).to eq(@campaign_id)
    expect(result.body["name"]).to eq('My Campaign')
  end

  it 'gets a list of all campaigns.' do
    result = @mg_obj.get("#{@domain}/campaigns", {:limit => 50})

    result.to_h!
    expect(result.body["total_count"]).to be > 0
  end

  it 'update a campaign.' do
    result = @mg_obj.put("#{@domain}/campaigns/#{@campaign_id}", {:name => 'My Updated Campaign',
                                                                  :id => @campaign_id})

    result.to_h!
    expect(result.body["message"]).to eq("Campaign updated")
    expect(result.body["campaign"]["id"]).to eq(@campaign_id)
    expect(result.body["campaign"]["name"]).to eq('My Updated Campaign')
  end

  it 'get campaign events.' do
    expect{@mg_obj.get("#{@domain}/campaigns/#{@campaign_id}/events", {:groupby => "clicked"})}.not_to raise_error
  end

  it 'get campaign stats.' do
    expect{@mg_obj.get("#{@domain}/campaigns/#{@campaign_id}/stats", {:groupby => "domain"})}.not_to raise_error
  end

  it 'removes a campaign' do
    @mg_obj.delete("#{@domain}/campaigns/#{@campaign_id}")
  end
end
