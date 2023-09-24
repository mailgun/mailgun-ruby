require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "mailing_list" }

describe 'For the Mailing Lists endpoint', vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN
    @ml_address = "integration_test_list@#{@domain}"
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

  it 'gets a list.' do
    result = @mg_obj.get("lists/#{@ml_address}")

    result.to_h!
    expect(result.body["list"]["address"]).to eq(@ml_address)
    expect(result.body["list"]["name"]).to eq('Integration Test List')
  end

  it 'gets a list of all lists.' do
    result = @mg_obj.get("lists", {:limit => 50})

    result.to_h!
    expect(result.body["total_count"]).to be > 0
  end

  it 'updates a list.' do
    result = @mg_obj.put("lists/#{@ml_address}",
                         {:address => @ml_address,
                          :name => 'Integration Test List Update',
                          :description => 'This list should be deleted automatically.',
                          :access_level => 'readonly'})

    result.to_h!
    expect(result.body["message"]).to eq("Mailing list has been updated")
    expect(result.body["list"]["address"]).to eq(@ml_address)
    expect(result.body["list"]["name"]).to eq('Integration Test List Update')
    expect(result.body["list"]["access_level"]).to eq('readonly')
  end

  it 'deletes a list' do
    @mg_obj.delete("lists/#{@ml_address}")
  end

end
