# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'routes', match_requests_on: %i[uri method body] }

describe 'For the Routes endpoint', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_client = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @mg_obj = Mailgun::Routes.new(@mg_client)
    @domain = TESTDOMAIN
    @forward_to = "alice@#{@domain}"
    @recipient = ".*@#{@domain}"
  end

  it 'creates a route' do
    result = @mg_obj.create({ priority: 10,
                              description: 'Integration Test Route',
                              expression: "match_recipient(\"#{@forward_to}\")",
                              action: "forward(\"#{@recipient}\")" })

    expect(result['message']).to eq('Route has been created')
    expect(result['route']['description']).to eq('Integration Test Route')
    expect(result['route']['actions']).to include("forward(\"#{@recipient}\")")
    expect(result['route']['expression']).to include("match_recipient(\"#{@forward_to}\")")
    expect(result['route']['priority']).to eq(10)
  end

  it 'creates a route with multiple actions' do
    result = @mg_obj.create({ priority: 10,
                              description: 'Integration Test Route',
                              expression: "match_recipient(\"#{@forward_to}\")",
                              action: ["forward(\"#{@recipient}\")", 'stop()'] })

    expect(result['message']).to eq('Route has been created')
    expect(result['route']['description']).to eq('Integration Test Route')
    expect(result['route']['actions'].count).to eq 2
    expect(result['route']['actions'][0]).to include("forward(\"#{@recipient}\")")
    expect(result['route']['actions'][1]).to include('stop()')
    expect(result['route']['expression']).to include("match_recipient(\"#{@forward_to}\")")
    expect(result['route']['priority']).to eq(10)
  end

  it 'gets a list of all routes.' do
    result = @mg_obj.list({ limit: 50 })

    expect(result.map { |route| route['description'] }).to include('Integration Test Route')
  end

  it 'gets the route.' do
    route_id = @mg_obj.list({ limit: 1 }).first['id']

    result = @mg_obj.get(route_id)

    expect(result['route']['description']).to eq('Integration Test Route')
    expect(result['route']['actions']).to include("forward(\"#{@recipient}\")")
    expect(result['route']['expression']).to include("match_recipient(\"#{@forward_to}\")")
    expect(result['route']['priority']).to eq(10)
  end

  it 'updates the route.' do
    route_id = @mg_obj.list({ limit: 1 }).first['id']

    result = @mg_obj.update(route_id, { priority: 10,
                                        description: 'Integration Test Route Update',
                                        expression: "match_recipient(\"#{@forward_to}\")",
                                        action: "forward(\"#{@recipient}\")" })

    expect(result['message']).to eq('Route has been updated')
    expect(result['description']).to eq('Integration Test Route Update')
    expect(result['actions']).to include("forward(\"#{@recipient}\")")
    expect(result['expression']).to include("match_recipient(\"#{@forward_to}\")")
    expect(result['priority']).to eq(10)
  end

  it 'removes a route' do
    route_id = @mg_obj.list({ limit: 1 }).first['id']

    expect(@mg_obj.remove(route_id)).to be(true)
  end
end
