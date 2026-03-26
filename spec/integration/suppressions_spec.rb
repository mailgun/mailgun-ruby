# frozen_string_literal: true

require 'spec_helper'

require 'mailgun'
require 'mailgun/suppressions'

vcr_opts = { cassette_name: 'suppressions', match_requests_on: %i[uri method body]  }

describe 'For the suppressions handling class', order: :defined, vcr: vcr_opts do
  let(:mg_obj) { Mailgun::Client.new(APIKEY, APIHOST, 'v3') }
  let(:suppress) { Mailgun::Suppressions.new(mg_obj, TESTDOMAIN) }
  let(:addresses) { %w[test1@example.com test2@example.org test3@example.net test4@example.info] }

  it 'can batch-add bounces' do
    bounces = []
    addresses.each do |addr|
      bounces.push({
                     address: addr,
                     code: 500,
                     error: 'integration testing'
                   })
    end

    response, nested = suppress.create_bounces bounces
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('4 addresses have been added to the bounces table')
    expect(nested.length).to eq(0)
  end

  it 'raises ParameterError if no bounce[:address] is present' do
    bounces = []
    bounces.push({
                   code: 500,
                   error: 'integration testing'
                 })

    expect { suppress.create_bounces bounces }.to raise_error(Mailgun::ParameterError)
  end

  it 'returns nil if no bounces passed' do
    response = suppress.create_bounces({})

    expect(response[0]).to eq(nil)
  end

  it 'creates a single bounce' do
    bounce = {
      address: 'test777@example.info',
      code: 777,
      error: 'integration testing123'
    }

    response = suppress.create_bounce bounce
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('Address has been added to the bounces table')
  end

  it 'fetches a single bounce' do
    response = suppress.get_bounce('test777@example.info')
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['address']).to eq('test777@example.info')
  end

  it 'removes a single bounce address' do
    addresses.each do |addr|
      response = suppress.delete_bounce addr
      response.to_h!

      expect(response.code).to eq(200)
      expect(response.body['message']).to eq('Bounced address has been removed')
    end
  end

  it 'removes all bounces' do
    response = suppress.delete_all_bounces
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('Bounced addresses for this domain have been removed')
  end

  it 'can batch-add unsubscribes with tags as string' do
    unsubscribes = []
    addresses.each do |addr|
      unsubscribes.push({
                          address: addr,
                          tag: '123'
                        })
    end

    response, nested = suppress.create_unsubscribes unsubscribes
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('4 addresses have been added to the unsubscribes table')
    expect(nested.length).to eq(0)
  end

  it 'can batch-add unsubscribes with tags as array' do
    unsubscribes = []
    addresses.each do |addr|
      unsubscribes.push({
                          address: addr,
                          tags: ['integration']
                        })
    end

    response, nested = suppress.create_unsubscribes unsubscribes
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('4 addresses have been added to the unsubscribes table')
    expect(nested.length).to eq(0)
  end

  it 'can batch-add unsubscribes with tags as digits' do
    unsubscribes = []
    addresses.each do |addr|
      unsubscribes.push({
                          address: addr,
                          tag: 123
                        })
    end

    response, nested = suppress.create_unsubscribes unsubscribes
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('4 addresses have been added to the unsubscribes table')
    expect(nested.length).to eq(0)
  end

  it 'raises ParameterError if no unsubscribe[:address] is present' do
    unsubscribes = []
    unsubscribes.push({
                        tag: 'integration'
                      })

    expect { suppress.create_unsubscribes unsubscribes }.to raise_error(Mailgun::ParameterError)
  end

  it 'returns nil if no unsubscribes passed' do
    response = suppress.create_unsubscribes({})

    expect(response[0]).to eq(nil)
  end

  it 'removes a single unsubscribe address' do
    addresses.each do |addr|
      response = suppress.delete_unsubscribe addr
      response.to_h!

      expect(response.code).to eq(200)
      expect(response.body['message']).to eq('Unsubscribe event has been removed')
    end
  end

  it 'creates a single unsubscribe' do
    response = suppress.create_unsubscribe({
      address: 'test777@example.com',
      tags: ['integration']
    })
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('Address has been added to the unsubscribes table')
  end

  it 'returns a single unsubscribe' do
    response = suppress.get_unsubscribe( 'test777@example.com')
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['address']).to eq('test777@example.com')
  end

  it 'returns all unsubscribers' do
    response = suppress.list_unsubscribes
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['items'][0]['address']).to eq('test777@example.com')
  end

  it 'can batch-add complaints' do
    complaints = []
    addresses.each do |addr|
      complaints.push address: addr
    end

    response, nested = suppress.create_complaints complaints
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('4 complaint addresses have been added to the complaints table')
    expect(nested.length).to eq(0)
  end

  it 'raises ParameterError if no complaint[:address] is present' do
    complaints = []
    complaints.push({
                      tag: 'integration'
                    })

    expect { suppress.create_complaints complaints }.to raise_error(Mailgun::ParameterError)
  end

  it 'returns nil if no complaints passed' do
    response = suppress.create_complaints({})

    expect(response[0]).to eq(nil)
  end

  it 'creates a single complaint' do
    response = suppress.create_complaint({ address: 'test777@example.com'})
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('Address has been added to the complaints table')
  end

  it 'returns a single complaint' do
    response = suppress.get_complaint( 'test777@example.com')
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['address']).to eq('test777@example.com')
  end

  it 'returns all complaints' do
    response = suppress.list_complaints
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['items'][0]['address']).to eq('test1@example.com')
  end

  it 'removes a single complaint address' do
    addresses.each do |addr|
      response = suppress.delete_complaint addr
      response.to_h!

      expect(response.code).to eq(200)
      expect(response.body['message']).to eq('Spam complaint has been removed')
    end
  end

  describe 'paging' do
    before do
      suppress.list_bounces
    end

    describe '#next' do
      it 'returns the response' do
        resp = suppress.next
        expect(resp.status).to eq(200)
        expect(JSON.parse(resp.body)).to include('items')
      end
    end

    describe '#prev' do
      it 'returns the response' do
        resp = suppress.prev
        expect(resp.status).to eq(200)
        expect(JSON.parse(resp.body)).to include('items')
      end
    end
  end

  context 'with 1000 or more entries' do
    let(:large_list) { Array.new(1000) { |i| { address: "user#{i}@example.com" } } }
    let(:client)  { double(:client) }
    let(:domain)  { 'example.com' }

    def stub_response(body = {})
      double(:response).tap do |r|
        allow(r).to receive(:to_h).and_return(body)
        allow(r).to receive(:to_h!).and_return(body)
        allow(r).to receive(:code).and_return(200)
        allow(r).to receive(:body).and_return(body)
      end
    end

    subject(:suppressions) { Mailgun::Suppressions.new(client, domain) }

    it 'splits bounces list and makes two POST requests' do
      expect(client).to receive(:post)
                          .with('example.com/bounces', anything, { 'Content-Type' => 'application/json' })
                          .twice
                          .and_return(stub_response)

      _resp, split = suppressions.create_bounces(large_list)
      expect(split).not_to be_empty
    end

    it 'splits unsubscribes list and makes two POST requests' do
      expect(client).to receive(:post)
                          .with('example.com/unsubscribes', anything, { 'Content-Type' => 'application/json' })
                          .twice
                          .and_return(stub_response)

      _resp, split = suppressions.create_unsubscribes(large_list)
      expect(split).not_to be_empty
    end

    it 'splits complaints list and makes two POST requests' do
      expect(client).to receive(:post)
                          .with('example.com/complaints', anything, { 'Content-Type' => 'application/json' })
                          .twice
                          .and_return(stub_response)

      _resp, split = suppressions.create_complaints(large_list)
      expect(split).not_to be_empty
    end
  end
end
