# frozen_string_literal: true

require 'spec_helper'

describe Mailgun::MailingLists do
  let(:client) { instance_double(Mailgun::Client, api_version: 'v3') }
  let(:lists) { described_class.new(client) }
  let(:list_address) { 'dev@mg.example.com' }
  let(:response) { instance_double(Mailgun::Response, to_h: body, to_h!: body, status: 200) }
  let(:body) { {} }

  describe '#list_pages' do
    let(:body) { { 'items' => [], 'paging' => { 'next' => 'https://api.mailgun.net/v3/lists/pages?page=next' } } }

    it 'gets a page of mailing lists' do
      expect(client).to receive(:get).with('lists/pages', { limit: 10, page: 'next' }).and_return(response)

      expect(lists.list_pages(limit: 10, page: 'next')).to eq(body)
    end
  end

  describe '#list_members' do
    let(:body) { { 'items' => [{ 'address' => 'jane@example.com' }], 'total_count' => 1 } }

    it 'gets the members of a list' do
      expect(client).to receive(:get)
        .with("lists/#{list_address}/members", { subscribed: true, limit: 50 }).and_return(response)

      expect(lists.list_members(list_address, subscribed: true, limit: 50)).to eq(body['items'])
    end
  end

  describe '#list_members_pages' do
    let(:body) { { 'items' => [], 'paging' => {} } }

    it 'gets a page of list members' do
      expect(client).to receive(:get)
        .with("lists/#{list_address}/members/pages", { page: 'next', address: 'jane@example.com' })
        .and_return(response)

      expect(lists.list_members_pages(list_address, page: 'next', address: 'jane@example.com')).to eq(body)
    end
  end

  describe '#create_member' do
    it 'sends Hash vars as a JSON string' do
      expect(client).to receive(:post)
        .with("lists/#{list_address}/members", { name: 'Jane', vars: '{"age":26}', address: 'jane@example.com' })
        .and_return(response)

      lists.create_member(list_address, 'jane@example.com', name: 'Jane', vars: { age: 26 })
    end

    it 'sends String vars as they are' do
      expect(client).to receive(:post)
        .with("lists/#{list_address}/members", { vars: '{"age":26}', address: 'jane@example.com' })
        .and_return(response)

      lists.create_member(list_address, 'jane@example.com', vars: '{"age":26}')
    end
  end

  describe '#update_member' do
    it 'sends Hash vars as a JSON string' do
      expect(client).to receive(:put)
        .with("lists/#{list_address}/members/jane@example.com", { vars: '{"age":27}' }).and_return(response)

      lists.update_member(list_address, 'jane@example.com', vars: { age: 27 })
    end
  end

  describe '#create_members' do
    let(:body) { { 'message' => 'Mailing list upload started', 'task-id' => '4321' } }
    let(:members) { [{ address: 'jane@example.com', name: 'Jane' }, 'bob@example.com'] }

    it 'sends the members as a JSON string' do
      expect(client).to receive(:post)
        .with("lists/#{list_address}/members.json",
              { upsert: true, members: '[{"address":"jane@example.com","name":"Jane"},"bob@example.com"]' })
        .and_return(response)

      expect(lists.create_members(list_address, members, upsert: true)).to eq(body)
    end

    it 'sends a JSON string of members as it is' do
      expect(client).to receive(:post)
        .with("lists/#{list_address}/members.json", { members: '["bob@example.com"]' }).and_return(response)

      lists.create_members(list_address, '["bob@example.com"]')
    end

    it 'raises a ParameterError when no members are given' do
      [nil, [], ''].each do |blank|
        expect { lists.create_members(list_address, blank) }
          .to raise_error(Mailgun::ParameterError, 'No members given to add')
      end
    end
  end

  describe '#import_members' do
    let(:csv) do
      Tempfile.new(['members', '.csv']).tap do |file|
        file.write("address,name\njane@example.com,Jane\n")
        file.rewind
      end
    end

    after { csv.close! }

    it 'uploads a CSV file by path' do
      expect(client).to receive(:post).with(
        "lists/#{list_address}/members.csv",
        hash_including(upsert: true, members: having_attributes(content_type: 'text/csv',
                                                                original_filename: File.basename(csv.path)))
      ).and_return(response)

      lists.import_members(list_address, csv.path, upsert: true)
    end

    it 'uploads a CSV from an IO' do
      expect(client).to receive(:post).with(
        "lists/#{list_address}/members.csv",
        { members: having_attributes(content_type: 'text/csv', original_filename: 'members.csv') }
      ).and_return(response)

      lists.import_members(list_address, csv)
    end

    it 'raises a ParameterError when no CSV is given' do
      [nil, ''].each do |blank|
        expect { lists.import_members(list_address, blank) }
          .to raise_error(Mailgun::ParameterError, 'No CSV file given to import members from')
      end
    end
  end

  describe 'address escaping' do
    it 'keeps @ and + and encodes characters that would break the path' do
      expect(client).to receive(:get).with('lists/dev+news@mg.example.com/members/a%2Fb%23c%3Fd%25e@example.com')
                                     .and_return(response)

      lists.get_member('dev+news@mg.example.com', 'a/b#c?d%e@example.com')
    end
  end

  describe 'parameter validation' do
    it 'raises a ParameterError when the list address is missing' do
      [nil, ''].each do |blank|
        expect { lists.get(blank) }.to raise_error(Mailgun::ParameterError, 'No address given to find the mailing list')
        expect { lists.list_members(blank) }
          .to raise_error(Mailgun::ParameterError, 'No list address given to list members of')
        expect { lists.create_member(blank, 'jane@example.com') }
          .to raise_error(Mailgun::ParameterError, 'No list address given to add the member to')
      end
    end

    it 'raises a ParameterError when the member address is missing' do
      [nil, ''].each do |blank|
        expect { lists.remove_member(list_address, blank) }
          .to raise_error(Mailgun::ParameterError, 'No member address given to remove')
      end
    end
  end

  describe 'api version' do
    let(:client) { instance_double(Mailgun::Client, api_version: 'v4') }

    it 'requires a v3 client' do
      expect { lists.list }.to raise_error(Mailgun::ParameterError, 'Client api version must be v3')
      expect { lists.add_member(list_address, 'jane@example.com') }
        .to raise_error(Mailgun::ParameterError, 'Client api version must be v3')
    end
  end
end
