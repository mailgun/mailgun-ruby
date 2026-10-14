# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'routes_match' }

describe 'For the Routes match endpoint', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_client = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @mg_obj = Mailgun::Routes.new(@mg_client)
    @domain = TESTDOMAIN || 'DOMAIN.TEST'
    @address = "integration_test_match@#{@domain}"
    @state = {}
  end

  it 'creates a route for the address' do
    result = @mg_obj.create({ priority: 0,
                              description: 'Integration Test Match Route',
                              expression: "match_recipient(\"#{@address}\")",
                              action: 'stop()' })

    expect(result['message']).to eq('Route has been created')
    @state[:route_id] = result['route']['id']
  end

  it 'finds the route that handles the address' do
    result = @mg_obj.match(@address)

    expect(result['route']['id']).to eq(@state[:route_id])
    expect(result['route']['expression']).to eq("match_recipient(\"#{@address}\")")
  end

  it 'removes the route' do
    expect(@mg_obj.remove(@state[:route_id])).to be(true)
  end

  describe 'argument checks' do
    it 'raises a ParameterError when the route ID is missing' do
      [nil, ''].each do |blank|
        expect { @mg_obj.get(blank) }.to raise_error(Mailgun::ParameterError, 'No route ID given to find')
        expect { @mg_obj.update(blank, { priority: 1 }) }
          .to raise_error(Mailgun::ParameterError, 'No route ID given to update')
        expect { @mg_obj.remove(blank) }.to raise_error(Mailgun::ParameterError, 'No route ID given to remove')
      end
    end

    it 'raises a ParameterError when the address to match is missing' do
      [nil, ''].each do |blank|
        expect { @mg_obj.match(blank) }.to raise_error(Mailgun::ParameterError, 'No address given to match')
      end
    end

    it 'requires a v3 client' do
      v4_routes = Mailgun::Routes.new(Mailgun::Client.new(APIKEY, APIHOST, 'v4', SSL))

      expect { v4_routes.list }.to raise_error(Mailgun::ParameterError, 'Client api version must be v3')
    end
  end
end
