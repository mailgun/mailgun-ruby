require 'spec_helper'
require 'mailgun'

vcr_opts = { cassette_name: 'analytics_tags' }

describe 'AnalyticsTags', vcr: vcr_opts do
  let(:api_version) { APIVERSION }
  let(:mg_client) { Mailgun::Client.new(APIKEY, APIHOST, api_version, SSL) }
  let(:mg_obj) { Mailgun::AnalyticsTags.new(mg_client) }
  let(:api_version) { 'v1' }

  describe '#update' do
    it 'updates a tag' do
      response = mg_obj.update('test1', 'test_description')

      expect(response).to be_truthy
    end
  end

  describe '#list' do
    it 'returns a list of tags' do
      response = mg_obj.list(
        {
          pagination: {
            sort: 'lastseen:desc',
            limit: 10
          },
          include_subaccounts: true
        }
      )

      expect(response[0]['account_id']).to eq('test')
      expect(response[0]['tag']).to eq('test1')
    end
  end

  describe '#remove' do
    it 'removes a tag' do
      response = mg_obj.remove('test1')

      expect(response).to be_truthy
    end
  end

  context '#limits' do
    it 'returns limits' do
      response = mg_obj.limits

      expect(response['limit']).to eq(100_000)
    end
  end
end
