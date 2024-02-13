require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "tags" }

describe 'For the tags endpoints', vcr: vcr_opts do
  let(:tag_name) { 'abtest-option-a' }
  let(:domain) { "integration-test.domain.invalid" }

  before(:all) do
    @mg_client = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @tags = Mailgun::Tags.new(@mg_client)
  end

  describe '#get_tags' do
    it 'returs tags info' do
      result = @tags.get_tags(domain)

      expect(result.first['tag']).to eq('You can track mails as tag-units!')
    end
  end

  describe '#get_tag' do
    it "return the tag's info" do
      result = @tags.get_tag(domain, tag_name)

      expect(result['tag']).to eq(tag_name)
    end
  end

  describe '#update' do
    it "returns true" do
      result = @tags.update(
        domain,
        tag_name,
        { description: 'new description 2' }
      )

      expect(result).to eq(true)
    end
  end

  describe '#get_tag_stats' do
    it "returns tag stats info" do
      result = @tags.get_tag_stats(
        domain,
        tag_name,
        { 
          event: 'accepted',
          start: 'Tue, 23 Jan 2024 11:23:45 EST',
          resolution: 'day'
        }
      )

      expect(result).to include('stats')
      expect(result['stats'].first['accepted']).to include(
        {
          'incoming' => 0,
          'outgoing' => 0,
          'total' => 0
        }
      )
    end
  end

  describe '#get_countries_aggregated_stats' do
    it "returns countries of origin for a given domain" do
      result = @tags.get_countries_aggregated_stats(
        domain,
        tag_name
      )

      expect(result).to include('country')
      expect(result['country']['ad']).to include(
        {
          'clicked' => 0,
          'complained' => 0,
          'opened' => 0,
          'unique_clicked' => 0,
          'unique_opened' => 0,
          'unsubscribed' => 0
        }
      )
    end
  end

  describe '#get_providers_aggregated_stats' do
    it "returns email providers for a given domain" do
      result = @tags.get_providers_aggregated_stats(
        domain,
        tag_name
      )

      expect(result).to include('provider')
      expect(result['provider']['aol.com']).to include(
        {
          'clicked' => 0,
          'complained' => 0,
          'opened' => 0,
          'unique_clicked' => 0,
          'unique_opened' => 0,
          'unsubscribed' => 0
        }
      )
    end
  end

  describe '#get_devices_aggregated_stats' do
    it "returns devices for a given domain" do
      result = @tags.get_devices_aggregated_stats(
        domain,
        tag_name
      )

      expect(result).to include('device')
      expect(result['device']['desktop']).to include(
        {
          'clicked' => 0,
          'complained' => 0,
          'opened' => 28,
          'unique_clicked' => 0,
          'unique_opened' => 24,
          'unsubscribed' => 0
        }
      )
    end
  end

  describe '#remove' do
    it "returns true" do
      result = @tags.remove(
        domain,
        tag_name
      )

      expect(result).to eq(true)
    end
  end
end
