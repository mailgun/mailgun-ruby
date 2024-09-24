require 'spec_helper'

RSpec.describe Mailgun::CommunicationError do
  describe '.new' do
    context "when the Response body doesn't have a `message` property" do
      it "doesn't raise an error" do
        expect do
          described_class.new('Boom!', Mailgun::Response.from_hash({ code: 401, body: '{}' }))
        end.not_to raise_error
      end
    end
  end
end
