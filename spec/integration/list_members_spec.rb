require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "list_members" }

describe 'For the Mailing Lists Members endpoint', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN
    @ml_address = "integration_test_list@#{@domain}"
    @ml_member = "integration_test_member_member@#{@domain}"
  end
  
  it 'creates a list' do
    result = @mg_obj.post("lists", {:address => @ml_address,
                           :name => 'Integration Test List',
                           :description => 'This list should be deleted automatically.',
                           :access_level => 'members'})
    result.to_h!
    expect(result.body["message"]).to eq("Mailing list has been created")
    expect(result.body["list"]["address"]).to eq(@ml_address)
    expect(result.body["list"]["name"]).to eq('Integration Test List')
  end

  it 'adds a list member' do
    result = @mg_obj.post("lists/#{@ml_address}/members",
                          {:address => @ml_member,
                           :name => 'Jane Doe',
                           :subscribed => true,
                           :upsert => 'no'})

    result.to_h!
    expect(result.body["message"]).to eq("Mailing list member has been created")
    expect(result.body["member"]["address"]).to eq(@ml_member)
    expect(result.body["member"]["name"]).to eq('Jane Doe')
  end
  
  it 'gets a list member.' do
    result = @mg_obj.get("lists/#{@ml_address}/members/#{@ml_member}")

    result.to_h!
    expect(result.body["member"]["address"]).to eq(@ml_member)
    expect(result.body["member"]["name"]).to eq('Jane Doe')
  end

  it 'updates a list member.' do
    result = @mg_obj.put("lists/#{@ml_address}/members/#{@ml_member}",
                         {:name => 'Jane Doe Update',
                          :subscribed => false})

    result.to_h!
    expect(result.body["message"]).to eq("Mailing list member has been updated")
    expect(result.body["member"]["address"]).to eq(@ml_member)
    expect(result.body["member"]["name"]).to eq('Jane Doe Update')
    expect(result.body["member"]["subscribed"]).to eq(false)
  end

  it 'removes a list member' do
    @mg_obj.delete("lists/#{@ml_address}/members/#{@ml_member}")
    @mg_obj.delete("lists/#{@ml_address}")
  end

end
