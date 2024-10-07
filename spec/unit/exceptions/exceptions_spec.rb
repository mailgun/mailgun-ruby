require 'spec_helper'

RSpec.describe Mailgun::CommunicationError do
  describe '.new' do
    context "when the Response body doesn't have a `message` property" do
      it "doesn't raise an error" do
        expect do
          described_class.new('Boom!', Mailgun::Response.from_hash({ code: 401, body: '{}' }))
        end.not_to raise_error
      end

      context "when the Response body has an `Error` property" do
        it "uses the `Error` property as the API message" do
          subject = described_class.new('Boom!', Mailgun::Response.from_hash({ code: 401, body: '{"Error":"unauthorized"}' }))

          expect(subject.message).to eq("Boom!: unauthorized")
        end
      end

      context "when the Response body has an `error` property" do
        it "uses the `Error` property as the API message" do
          subject = described_class.new('Boom!', Mailgun::Response.from_hash({ code: 401, body: '{"error":"not found"}' }))

          expect(subject.message).to eq("Boom!: not found")
        end
      end

    end
  end
end
