# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'yaml'
require 'mailgun/response'
require 'mailgun/exceptions/exceptions'

describe Mailgun::Response do
  subject(:response) { described_class.new(http_response) }

  let(:json_body) { '{"id":"<message-id@example.com>","message":"Queued. Thank you."}' }
  let(:status200) { 200 }

  # Minimal double that mimics a RestClient::Response
  let(:http_response) do
    double('http_response', body: json_body, status: status200)
  end

  # ---------------------------------------------------------------------------
  # .new
  # ---------------------------------------------------------------------------
  describe '#initialize' do
    it 'sets body from the underlying response' do
      expect(response.body).to eq(json_body)
    end

    it 'sets status from the underlying response' do
      expect(response.status).to eq(status200)
    end

    it 'aliases code to status' do
      expect(response.code).to eq(status200)
    end
  end

  # ---------------------------------------------------------------------------
  # .from_hash
  # ---------------------------------------------------------------------------
  describe '.from_hash' do
    subject(:from_hash_response) do
      described_class.from_hash(body: json_body, status: status200)
    end

    it 'returns a Response instance' do
      expect(from_hash_response).to be_a(described_class)
    end

    it 'sets body from the hash' do
      expect(from_hash_response.body).to eq(json_body)
    end

    it 'sets status from the hash' do
      expect(from_hash_response.status).to eq(status200)
    end

    it 'aliases code to status' do
      expect(from_hash_response.code).to eq(status200)
    end
  end

  # ---------------------------------------------------------------------------
  # #to_h
  # ---------------------------------------------------------------------------
  describe '#to_h' do
    it 'returns a Hash' do
      expect(response.to_h).to be_a(Hash)
    end

    it 'correctly parses the JSON body' do
      result = response.to_h
      expect(result['id']).to eq('<message-id@example.com>')
      expect(result['message']).to eq('Queued. Thank you.')
    end

    it 'does not mutate the body attribute' do
      expect { response.to_h }.not_to(change(response, :body))
    end

    context 'when the body is invalid JSON' do
      let(:http_response) { double('http_response', body: 'not-json', status: 200) }

      it 'raises a Mailgun::ParseError' do
        expect { response.to_h }.to raise_error(Mailgun::ParseError)
      end
    end
  end

  # ---------------------------------------------------------------------------
  # #to_h!
  # ---------------------------------------------------------------------------
  describe '#to_h!' do
    it 'returns a Hash' do
      expect(response.to_h!).to be_a(Hash)
    end

    it 'correctly parses the JSON body' do
      result = response.to_h!
      expect(result['message']).to eq('Queued. Thank you.')
    end

    it 'replaces body with the parsed Hash' do
      response.to_h!
      expect(response.body).to be_a(Hash)
      expect(response.body['id']).to eq('<message-id@example.com>')
    end

    context 'when the body is invalid JSON' do
      let(:http_response) { double('http_response', body: 'not-json', status: 200) }

      it 'raises a Mailgun::ParseError' do
        expect { response.to_h! }.to raise_error(Mailgun::ParseError)
      end
    end
  end

  # ---------------------------------------------------------------------------
  # #to_yaml
  # ---------------------------------------------------------------------------
  describe '#to_yaml' do
    it 'returns a String' do
      expect(response.to_yaml).to be_a(String)
    end

    it 'returns valid YAML that round-trips back to the expected hash' do
      parsed = YAML.safe_load(response.to_yaml)
      expect(parsed['id']).to eq('<message-id@example.com>')
      expect(parsed['message']).to eq('Queued. Thank you.')
    end

    it 'does not mutate the body attribute' do
      expect { response.to_yaml }.not_to(change(response, :body))
    end

    context 'when the body is invalid JSON' do
      let(:http_response) { double('http_response', body: 'not-json', status: 200) }

      it 'raises a Mailgun::ParseError' do
        expect { response.to_yaml }.to raise_error(Mailgun::ParseError)
      end
    end
  end

  # ---------------------------------------------------------------------------
  # #to_yaml!
  # ---------------------------------------------------------------------------
  describe '#to_yaml!' do
    it 'returns a String' do
      expect(response.to_yaml!).to be_a(String)
    end

    it 'returns valid YAML that round-trips back to the expected hash' do
      yaml_str = response.to_yaml!
      parsed = YAML.safe_load(yaml_str)
      expect(parsed['message']).to eq('Queued. Thank you.')
    end

    it 'replaces body with the YAML string' do
      response.to_yaml!
      expect(response.body).to be_a(String)
      expect(response.body).to include('Queued. Thank you.')
    end

    context 'when the body is invalid JSON' do
      let(:http_response) { double('http_response', body: 'not-json', status: 200) }

      it 'raises a Mailgun::ParseError' do
        expect { response.to_yaml! }.to raise_error(Mailgun::ParseError)
      end
    end
  end

  # ---------------------------------------------------------------------------
  # #success?
  # ---------------------------------------------------------------------------
  describe '#success?' do
    context 'with a 2xx status code' do
      [200, 201, 204, 299].each do |code|
        it "returns true for status #{code}" do
          allow(http_response).to receive(:status).and_return(code)
          expect(described_class.new(http_response).success?).to be(true)
        end
      end
    end

    context 'with a non-2xx status code' do
      [400, 401, 403, 404, 422, 500, 503].each do |code|
        it "returns false for status #{code}" do
          allow(http_response).to receive(:status).and_return(code)
          expect(described_class.new(http_response).success?).to be(false)
        end
      end
    end

    it 'returns false for status 199 (just below 2xx range)' do
      allow(http_response).to receive(:status).and_return(199)
      expect(described_class.new(http_response).success?).to be(false)
    end

    it 'returns false for status 300 (just above 2xx range)' do
      allow(http_response).to receive(:status).and_return(300)
      expect(described_class.new(http_response).success?).to be(false)
    end
  end

  # ---------------------------------------------------------------------------
  # attr_accessor sanity checks
  # ---------------------------------------------------------------------------
  describe 'attribute accessors' do
    it 'allows body to be overwritten' do
      response.body = 'new body'
      expect(response.body).to eq('new body')
    end

    it 'allows status to be overwritten' do
      response.status = 404
      expect(response.status).to eq(404)
    end

    it 'allows code to be overwritten' do
      response.code = 500
      expect(response.code).to eq(500)
    end
  end
end
