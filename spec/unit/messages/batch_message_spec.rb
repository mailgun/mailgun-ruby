require 'spec_helper'

describe 'BatchMessage attribute readers' do
  it 'should be readable' do
    @mb_client = Mailgun::UnitClient.new("messages")
    @mb_obj = Mailgun::BatchMessage.new(@mb_client, "example.com")

    expect(@mb_obj).to respond_to(:message_ids)
    expect(@mb_obj).to respond_to(:message)
    expect(@mb_obj).to respond_to(:counters)
    expect(@mb_obj).to respond_to(:recipient_variables)
    expect(@mb_obj).to respond_to(:domain)
  end
end

describe 'The instantiation of Batch Message' do

  before(:each) do
    @mb_client = Mailgun::UnitClient.new("messages")
    @mb_obj = Mailgun::BatchMessage.new(@mb_client, "example.com")
  end

  it 'contains Message, which should be of type Hash and empty' do
    expect(@mb_obj.message).to be_a(Hash)
    expect(@mb_obj.message.length).to eq(0)
  end

  it 'contains recipient_variables, which should be of type Hash and empty' do
    expect(@mb_obj.recipient_variables).to be_a(Hash)
    expect(@mb_obj.recipient_variables.length).to eq(0)
  end

  it 'contains domain, which should be of type string and contain example.com' do
    expect(@mb_obj.domain).to be_a(String)
    expect(@mb_obj.domain).to eq('example.com')
  end

  it 'contains message_ids, which should be of type hash and empty' do
    expect(@mb_obj.message_ids).to be_a(Hash)
    expect(@mb_obj.message_ids.length).to eq(0)
  end

  it 'contains counters, which should be of type hash and contain several important counters' do
    expect(@mb_obj.counters).to be_a(Hash)
    expect(@mb_obj.counters).to include(:recipients)
  end

  it 'contains counters, which should be of type hash and contain several important counters' do
    expect(@mb_obj.counters).to be_a(Hash)

    expect(@mb_obj.counters).to include(:recipients)
    expect(@mb_obj.counters[:recipients]).to include(:to)
    expect(@mb_obj.counters[:recipients]).to include(:cc)
    expect(@mb_obj.counters[:recipients]).to include(:bcc)

    expect(@mb_obj.counters).to include(:attributes)
    expect(@mb_obj.counters[:attributes]).to include(:attachment)
    expect(@mb_obj.counters[:attributes]).to include(:campaign_id)
    expect(@mb_obj.counters[:attributes]).to include(:custom_option)
    expect(@mb_obj.counters[:attributes]).to include(:tag)
  end
end

describe 'The method add_recipient' do
  before(:each) do
    @mb_client = Mailgun::UnitClient.new("messages")
    @mb_obj = Mailgun::BatchMessage.new(@mb_client, "example.com")
    @address_1   = 'jane@example.com'
    @variables_1 = {'first' => 'Jane', 'last' => 'Doe', 'tracking' => 'ABC123'}
    @address_2   = 'bob@example.com'
    @variables_2 = {'first' => 'Bob', 'last' => 'Doe', 'tracking' => 'DEF123'}
    @address_3   = 'sam@example.com'
    @variables_3 = {'first' => 'Sam', 'last' => 'Doe', 'tracking' => 'GHI123'}
  end

  it 'adds 1,000 recipients to the message body and validates counter is incremented then reset' do
    recipient_type = :to
    1000.times do
      @mb_obj.add_recipient(recipient_type, @address_1, @variables_1)
    end

    expect(@mb_obj.counters[:recipients][recipient_type]).to eq(1000)
    
    @mb_obj.add_recipient(recipient_type, @address_1, @variables_1)
    
    expect(@mb_obj.counters[:recipients][recipient_type]).to eq(1)
  end

  it 'adds recipients to the message, calls finalize, and cleans up' do
    recipient_type = :to
    1000.times do
      @mb_obj.add_recipient(recipient_type, @address_1, @variables_1)
    end

    expect(@mb_obj.counters[:recipients][recipient_type]).to eq(1000)
    @mb_obj.finalize

    expect(@mb_obj.message['recipient-variables'].length).to eq(0)
    expect(@mb_obj.message[:to].length).to eq(0)
    expect(@mb_obj.counters[:recipients][recipient_type]).to eq(0)
  end

  it 'adds 5,005 recipients to the message body and validates we receive message_ids back' do
    recipient_type = :to
    5005.times do
      @mb_obj.add_recipient(recipient_type, @address_1, @variables_1)
    end
    @mb_obj.finalize

    expect(@mb_obj.message_ids.length).to eq(6)
  end

  it 'sets recipient-variables, for batch expansion' do
    recipient_type = :to
    @mb_obj.add_recipient(recipient_type, @address_1, @variables_1)

    expect(@mb_obj.recipient_variables[@address_1]).to eq(@variables_1)
  end

  it 'sets multiple recipient-variables, for batch expansion' do
    recipient_type = :to
    @mb_obj.add_recipient(recipient_type, @address_1, @variables_1)
    @mb_obj.add_recipient(recipient_type, @address_2, @variables_2)
    @mb_obj.add_recipient(recipient_type, @address_3, @variables_3)
    
    expect(@mb_obj.recipient_variables[@address_1]).to eq(@variables_1)
    expect(@mb_obj.recipient_variables[@address_2]).to eq(@variables_2)
    expect(@mb_obj.recipient_variables[@address_3]).to eq(@variables_3)
  end

end
