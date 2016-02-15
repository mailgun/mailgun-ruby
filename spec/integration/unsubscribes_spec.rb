require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "unsubscribes" }

describe 'For the Unsubscribes endpoint', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN
    @email = "integration-test-email@#{TESTDOMAIN}"
  end

  it 'adds an unsubscriber' do
    result = @mg_obj.post "#{@domain}/unsubscribes", address: @email, tag: '*'

    result.to_h!
    expect(result.body["message"]).to eq("Address has been added to the unsubscribes table")
    expect(result.body["address"]).to eq(@email)
  end

  it 'get an unsubscribee.' do
    result = @mg_obj.get "#{@domain}/unsubscribes/#{@email}"

    result.to_h!
    expect(result.body["address"]).to eq(@email)
  end

  it 'gets a list of unsubscribes.' do
    result = @mg_obj.get "#{@domain}/unsubscribes"

    result.to_h!
    expect(result.body["items"].length).to be > 0
  end

  it 'removes an unsubscribee' do
    result = @mg_obj.delete "#{@domain}/unsubscribes/#{@email}"

    result.to_h!
    expect(result.body['address']).to eq(@email)
    expect(result.body["message"]).to eq("Unsubscribe event has been removed")
  end
end
