# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'mailing_list' }

describe 'For the Mailing Lists endpoint', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_client = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @mg_obj = Mailgun::MailingLists.new(@mg_client)
    @domain = TESTDOMAIN || 'DOMAIN.TEST'
    @ml_address = "integration_test_list@#{@domain}"
  end

  it 'creates a list' do
    result = @mg_obj.create(@ml_address, { name: 'Integration Test List',
                                           description: 'This list should be deleted automatically.',
                                           access_level: 'members' })

    expect(result['message']).to eq('Mailing list has been created')
    expect(result['list']['address']).to eq(@ml_address)
    expect(result['list']['name']).to eq('Integration Test List')
  end

  it 'gets a list.' do
    result = @mg_obj.get(@ml_address)

    expect(result['list']['address']).to eq(@ml_address)
    expect(result['list']['name']).to eq('Integration Test List')
  end

  it 'gets a list of all lists.' do
    result = @mg_obj.list({ limit: 50 })

    expect(result.map { |list| list['address'] }).to include(@ml_address)
  end

  it 'updates a list.' do
    result = @mg_obj.update(@ml_address, { address: @ml_address,
                                           name: 'Integration Test List Update',
                                           description: 'This list should be deleted automatically.',
                                           access_level: 'readonly' })

    expect(result['message']).to eq('Mailing list has been updated')
    expect(result['list']['address']).to eq(@ml_address)
    expect(result['list']['name']).to eq('Integration Test List Update')
    expect(result['list']['access_level']).to eq('readonly')
  end

  it 'deletes a list' do
    expect(@mg_obj.remove(@ml_address)).to be(true)
  end
end
