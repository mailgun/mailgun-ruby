require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "events" }

describe 'For the Events endpoint', vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN
  end

  it 'get an event.' do
    result = @mg_obj.get("#{@domain}/events", {:limit => 1})

    result.to_h!
    expect(result.body["items"].length).to be_within(1).of(1)
    expect(result.body["paging"]).to include("next")
    expect(result.body["paging"]).to include("previous")
  end
end
