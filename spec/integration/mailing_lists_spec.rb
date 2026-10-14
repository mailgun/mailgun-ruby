# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'mailing_lists' }

describe 'For the Mailing Lists paging and bulk endpoints', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_client = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @mg_obj = Mailgun::MailingLists.new(@mg_client)
    @domain = TESTDOMAIN || 'DOMAIN.TEST'
    @ml_address = "integration_test_bulk_list@#{@domain}"
    @jane = "integration_test_jane@#{@domain}"
    @bob = "integration_test_bob+news@#{@domain}"
  end

  it 'creates a list' do
    result = @mg_obj.create(@ml_address, { name: 'Integration Test Bulk List',
                                           description: 'This list should be deleted automatically.' })

    expect(result['list']['address']).to eq(@ml_address)
  end

  it 'adds members from JSON' do
    result = @mg_obj.create_members(@ml_address, [{ address: @jane, name: 'Jane Doe', vars: { age: 26 } }, @bob],
                                    { upsert: true })

    expect(result['message']).to eq('Mailing list has been updated')
    expect(result['list']['address']).to eq(@ml_address)
  end

  it 'lists the members' do
    result = @mg_obj.list_members(@ml_address)

    expect(result.map { |member| member['address'] }).to contain_exactly(@jane, @bob)
  end

  it 'gets a member with a plus sign in the address' do
    result = @mg_obj.get_member(@ml_address, @bob)

    expect(result['member']['address']).to eq(@bob)
  end

  it 'keeps member vars sent as a Hash' do
    result = @mg_obj.get_member(@ml_address, @jane)

    expect(result['member']['vars']).to eq('age' => 26)
  end

  it 'lists the members by page' do
    result = @mg_obj.list_members_pages(@ml_address, { limit: 1 })

    expect(result['items'].size).to eq(1)
    expect(result['paging'].keys).to include('first', 'next', 'previous', 'last')
  end

  it 'lists mailing lists by page' do
    result = @mg_obj.list_pages({ limit: 1 })

    expect(result['items'].size).to eq(1)
    expect(result['paging'].keys).to include('first', 'next', 'previous', 'last')
  end

  it 'imports members from a CSV file' do
    csv = Tempfile.new(['members', '.csv'])
    csv.write("address,name\nintegration_test_carol@#{@domain},Carol\n")
    csv.close

    result = @mg_obj.import_members(@ml_address, csv.path, { upsert: true })

    expect(result['message']).to eq('Mailing list upload started in background')
    expect(result['list']['address']).to eq(@ml_address)
  ensure
    csv&.unlink
  end

  it 'removes the list' do
    expect(@mg_obj.remove(@ml_address)).to be(true)
  end

  describe 'argument checks' do
    it 'raises a ParameterError when the list address is missing' do
      [nil, ''].each do |blank|
        expect { @mg_obj.get(blank) }
          .to raise_error(Mailgun::ParameterError, 'No address given to find the mailing list')
        expect { @mg_obj.list_members(blank) }
          .to raise_error(Mailgun::ParameterError, 'No list address given to list members of')
      end
    end

    it 'raises a ParameterError when the member address is missing' do
      [nil, ''].each do |blank|
        expect { @mg_obj.remove_member(@ml_address, blank) }
          .to raise_error(Mailgun::ParameterError, 'No member address given to remove')
      end
    end

    it 'raises a ParameterError when no members or CSV are given' do
      expect { @mg_obj.create_members(@ml_address, []) }
        .to raise_error(Mailgun::ParameterError, 'No members given to add')
      expect { @mg_obj.import_members(@ml_address, nil) }
        .to raise_error(Mailgun::ParameterError, 'No CSV file given to import members from')
    end

    it 'requires a v3 client' do
      v4_lists = Mailgun::MailingLists.new(Mailgun::Client.new(APIKEY, APIHOST, 'v4', SSL))

      expect { v4_lists.list }.to raise_error(Mailgun::ParameterError, 'Client api version must be v3')
    end
  end
end
