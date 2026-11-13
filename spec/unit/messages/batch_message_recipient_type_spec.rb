# frozen_string_literal: true

require 'json'
require_relative '../../../lib/mailgun/chains'
require_relative '../../../lib/mailgun/messages/message_builder'
require_relative '../../../lib/mailgun/messages/batch_message'

RSpec.describe Mailgun::BatchMessage do
  let(:client) { double('client') }
  let(:batch) { described_class.new(client, 'example.com') }

  %i[to cc bcc].each do |type|
    [type, type.to_s].each do |input|
      it "sends and clears a #{input.inspect} recipient on finalize" do
        response = double('response', to_h!: { 'id' => '<batch@example.com>' })
        expected = hash_including(
          type => ['jane@example.com'],
          'recipient-variables' => JSON.generate('jane@example.com' => { id: 0 })
        )
        expect(client).to receive(:send_message).with('example.com', expected).once.and_return(response)

        batch.add_recipient(input, 'jane@example.com')

        expect(batch.finalize).to eq('batch@example.com' => 1)
        expect(batch.message[type]).to be_empty
        expect(batch.recipient_variables).to be_empty
        expect(batch.counters[:recipients][type]).to eq(0)
        expect(batch.finalize).to eq('batch@example.com' => 1)
      end
    end

    it "shares the #{type} batch limit between string and symbol recipients" do
      sizes = []
      allow(client).to receive(:send_message) do |_domain, payload|
        sizes << payload.fetch(type).size
        double('response', to_h!: { 'id' => "<batch-#{sizes.size}@example.com>" })
      end

      1001.times do |index|
        batch.add_recipient(index.even? ? type.to_s : type, "recipient#{index}@example.com")
      end
      expect(sizes).to eq([1000])
      expect(batch.finalize).to eq('batch-1@example.com' => 1000, 'batch-2@example.com' => 1)
      expect(sizes).to eq([1000, 1])
    end
  end
end
