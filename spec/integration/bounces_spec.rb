require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "bounces" }

describe 'For the Bounces endpoint', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN
    @email = "integration-test-email@#{TESTDOMAIN}"
  end

  it 'creates a bounce' do
    @result = @mg_obj.post("#{@domain}/bounces",
                           {:address => @email,
                            :code => 550,
                            :error => "Integration Test"})

    @result.to_h!
    expect(@result.body["message"]).to eq("Address has been added to the bounces table")
    expect(@result.body["address"]).to eq(@email)
  end

  it 'get a bounce.' do
    result = @mg_obj.get("#{@domain}/bounces/#{@email}")

    result.to_h!
    expect(result.body["code"]).to eq("550")
    expect(result.body["address"]).to eq(@email)
    expect(result.body["error"]).to eq("Integration Test")
  end

  it 'gets a list of bounces.' do
    result = @mg_obj.get("#{@domain}/bounces")

    result.to_h!
    expect(result.body["items"].length).to be > 0
  end

  it 'deletes a bounce' do
    @mg_obj.delete("#{@domain}/bounces/#{@email}")
  end

end
