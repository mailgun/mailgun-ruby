require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "webhooks" }

describe 'For the webhooks endpoint', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN
    @testhook = 'accepted'
    @testhookup = 'accepted'
  end

  it 'creates a webhook' do
    result = @mg_obj.post("domains/#{@domain}/webhooks", { id: @testhook,
                                                           url: "http://example.com/mailgun/events/#{@testhook}" } )

    result.to_h!
    expect(result.body["message"]).to eq("Webhook has been created")
    expect(result.body["webhook"]["urls"]).to include("http://example.com/mailgun/events/#{@testhook}")
  end

  it 'gets a webhook.' do
    result = @mg_obj.get("domains/#{@domain}/webhooks/#{@testhook}")

    result.to_h!
    expect(result.body["webhook"]["urls"]).to include("http://example.com/mailgun/events/#{@testhook}")
  end

  it 'gets a list of all webhooks.' do
    result = @mg_obj.get("domains/#{@domain}/webhooks")

    result.to_h!
    expect(result.body["webhooks"]["accepted"]["urls"]).to include("http://example.com/mailgun/events/#{@testhook}")
  end

  it 'updates a webhook.' do
    result = @mg_obj.put("domains/#{@domain}/webhooks/#{@testhook}", {:id => @testhook,
                                                                :url => "http://example.com/mailgun/events/#{@testhookup}"})

    result.to_h!
    expect(result.body["message"]).to eq("Webhook has been updated")
    expect(result.body["webhook"]["urls"]).to include("http://example.com/mailgun/events/#{@testhookup}")
  end

  it 'removes a webhook' do
    result = @mg_obj.delete("domains/#{@domain}/webhooks/#{@testhook}")

    result.to_h!
    expect(result.body['message']).to eq("Webhook has been deleted")
    expect(result.body['webhook']['urls']).to include("http://example.com/mailgun/events/#{@testhookup}")
  end

end
