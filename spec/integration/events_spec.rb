require 'spec_helper'
require 'mailgun'
require 'mailgun/events/events'

vcr_opts = { :cassette_name => "events" }

describe 'For the Events endpoint', vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN
    @events = Mailgun::Events.new(@mg_obj, @domain)
  end

  it 'can get an event.' do
    result = @mg_obj.get("#{@domain}/events", {:limit => 1})

    result.to_h!
    expect(result.body["items"].length).to be_within(1).of(1)
    expect(result.body["paging"]).to include("next")
    expect(result.body["paging"]).to include("previous")
  end

  it 'can iterate over all events with `each`' do
    @events.each do |e|
      expect(e["id"]).to eq("JAx9z641TuGGUyaJlD9sCQ")
    end
  end
end
