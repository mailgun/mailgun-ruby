require 'spec_helper'

require 'mailgun'
require 'mailgun/suppressions'

vcr_opts = { :cassette_name => 'suppressions' }

describe 'For the suppressions handling class', order: :defined, vcr: vcr_opts do

  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY)
    @suppress = Mailgun::Suppressions.new(@mg_obj, TESTDOMAIN)

    @addresses = ['test1@example.com', 'test2@example.org', 'test3@example.net', 'test4@example.info']
  end

  it 'can batch-add bounces' do
    bounces = []
    @addresses.each do |addr|
      bounces.push({
        :address => addr,
        :code => 500,
        :error => 'integration testing',
      })
    end

    response, nested = @suppress.create_bounces bounces
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('4 addresses have been added to the bounces table')
    expect(nested.length).to eq(0)
  end

  it 'raises ParameterError if no bounce[:address] is present' do
    bounces = []
    bounces.push({
      :code => 500,
      :error => 'integration testing',
    })

    expect { @suppress.create_bounces bounces }.to raise_error(Mailgun::ParameterError)
  end

  it 'removes a single bounce address' do
    @addresses.each do |addr|
      response = @suppress.delete_bounce addr
      response.to_h!

      expect(response.code).to eq(200)
      expect(response.body['message']).to eq('Bounced address has been removed')
    end
  end

  it 'can batch-add unsubscribes' do
    unsubscribes = []
    @addresses.each do |addr|
      unsubscribes.push({
        :address => addr,
        :tag => 'integration',
      })
    end

    response, nested = @suppress.create_unsubscribes unsubscribes
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('4 addresses have been added to the unsubscribes table')
    expect(nested.length).to eq(0)
  end

  it 'raises ParameterError if no unsubscribe[:address] is present' do
    unsubscribes = []
    unsubscribes.push({
      :tag => 'integration',
    })

    expect { @suppress.create_unsubscribes unsubscribes }.to raise_error(Mailgun::ParameterError)
  end

  it 'removes a single unsubscribe address' do
    @addresses.each do |addr|
      response = @suppress.delete_unsubscribe addr
      response.to_h!

      expect(response.code).to eq(200)
      expect(response.body['message']).to eq('Unsubscribe event has been removed')
    end
  end

  it 'can batch-add complaints' do
    complaints = []
    @addresses.each do |addr|
      complaints.push :address => addr
    end

    response, nested = @suppress.create_complaints complaints
    response.to_h!

    expect(response.code).to eq(200)
    expect(response.body['message']).to eq('4 complaint addresses have been added to the complaints table')
    expect(nested.length).to eq(0)
  end

  it 'raises ParameterError if no complaint[:address] is present' do
    complaints = []
    complaints.push({
      :tag => 'integration',
    })

    expect { @suppress.create_complaints complaints }.to raise_error(Mailgun::ParameterError)
  end

  it 'removes a single complaint address' do
    @addresses.each do |addr|
      response = @suppress.delete_complaint addr
      response.to_h!

      expect(response.code).to eq(200)
      expect(response.body['message']).to eq('Spam complaint has been removed')
    end
  end

  # TODO: Add tests for pagination support.
end

