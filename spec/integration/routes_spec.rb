require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "routes" }

describe 'For the Routes endpoint', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN
    @forward_to = "alice@#{@domain}"
    @recipient = ".*@#{@domain}"
  end

  it 'creates a route' do
    result = @mg_obj.post("routes",  { priority: 10,
                                       description: 'Integration Test Route',
                                       expression: "match_recipient(\"#{@forward_to}\")",
                                       action: "forward(\"#{@recipient}\")" })

    result.to_h!
    expect(result.body["message"]).to eq("Route has been created")
    expect(result.body["route"]["description"]).to eq("Integration Test Route")
    expect(result.body["route"]["actions"]).to include("forward(\"#{@recipient}\")")
    expect(result.body["route"]["expression"]).to include("match_recipient(\"#{@forward_to}\")")
    expect(result.body["route"]["priority"]).to eq(10)
  end

  it 'gets a list of all routes.' do
    result = @mg_obj.get("routes", {:limit => 50})

    result.to_h!
    expect(result.body["total_count"]).to be > 0
  end

  it 'gets the route.' do
    result = @mg_obj.get("routes", {:limit => 1})
    route_id = result.to_h['items'].first['id']

    result = @mg_obj.get("routes/#{route_id}")

    result.to_h!
    expect(result.body["route"]["description"]).to eq("Integration Test Route")
    expect(result.body["route"]["actions"]).to include("forward(\"#{@recipient}\")")
    expect(result.body["route"]["expression"]).to include("match_recipient(\"#{@forward_to}\")")
    expect(result.body["route"]["priority"]).to eq(10)
  end

  it 'updates the route.' do
    result = @mg_obj.get("routes", {:limit => 1})
    route_id = result.to_h['items'].first['id']

    result = @mg_obj.put("routes/#{route_id}",  {:priority => 10,
                                                  :description => 'Integration Test Route Update',
                                                  :expression => "match_recipient(\"#{@forward_to}\")",
                                                  :action => "forward(\"#{@recipient}\")"})

    result.to_h!
    expect(result.body["message"]).to eq("Route has been updated")
    expect(result.body["description"]).to eq("Integration Test Route Update")
    expect(result.body["actions"]).to include("forward(\"#{@recipient}\")")
    expect(result.body["expression"]).to include("match_recipient(\"#{@forward_to}\")")
    expect(result.body["priority"]).to eq(10)
  end

  it 'removes a route' do
    result = @mg_obj.get("routes", {:limit => 1})
    route_id = result.to_h['items'].first['id']

    @mg_obj.delete("routes/#{route_id}")

    result.to_h!
  end

end
