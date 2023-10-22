require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "complaints" }

describe 'For the Complaints endpoint', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN
    @email = "integration-test-email@#{TESTDOMAIN}"
  end

  it 'creates a complaint' do
    @result = @mg_obj.post("#{@domain}/complaints", {:address => @email})

    @result.to_h!
    expect(@result.body["message"]).to eq("Address has been added to the complaints table")
    expect(@result.body["address"]).to eq(@email)
  end

  it 'get a complaint.' do
    result = @mg_obj.get("#{@domain}/complaints/#{@email}")

    result.to_h!
    expect(result.body["address"]).to eq(@email)
  end

  it 'gets a list of complaints.' do
    result = @mg_obj.get("#{@domain}/complaints")

    result.to_h!
    expect(result.body["items"].length).to be > 0
  end

  it 'removes a complaint' do
    @mg_obj.delete("#{@domain}/complaints/#{@email}")
  end
end
