# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'list_members' }

describe 'For the Mailing Lists Members endpoint', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_client = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @mg_obj = Mailgun::MailingLists.new(@mg_client)
    @domain = TESTDOMAIN
    @ml_address = "integration_test_list@#{@domain}"
    @ml_member = "integration_test_member_member@#{@domain}"
  end

  it 'creates a list' do
    result = @mg_obj.create(@ml_address, { name: 'Integration Test List',
                                           description: 'This list should be deleted automatically.',
                                           access_level: 'members' })

    expect(result['message']).to eq('Mailing list has been created')
    expect(result['list']['address']).to eq(@ml_address)
    expect(result['list']['name']).to eq('Integration Test List')
  end

  it 'adds a list member' do
    result = @mg_obj.create_member(@ml_address, @ml_member, { name: 'Jane Doe',
                                                              subscribed: true,
                                                              upsert: 'no' })

    expect(result['message']).to eq('Mailing list member has been created')
    expect(result['member']['address']).to eq(@ml_member)
    expect(result['member']['name']).to eq('Jane Doe')
  end

  it 'gets a list member.' do
    result = @mg_obj.get_member(@ml_address, @ml_member)

    expect(result['member']['address']).to eq(@ml_member)
    expect(result['member']['name']).to eq('Jane Doe')
  end

  it 'updates a list member.' do
    result = @mg_obj.update_member(@ml_address, @ml_member, { name: 'Jane Doe Update',
                                                              subscribed: false })

    expect(result['message']).to eq('Mailing list member has been updated')
    expect(result['member']['address']).to eq(@ml_member)
    expect(result['member']['name']).to eq('Jane Doe Update')
    expect(result['member']['subscribed']).to be(false)
  end

  it 'removes a list member' do
    expect(@mg_obj.remove_member(@ml_address, @ml_member)).to be(true)
  end

  it 'removes the list' do
    expect(@mg_obj.remove(@ml_address)).to be(true)
  end
end
