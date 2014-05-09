require 'spec_helper'

describe 'BatchMessage attribute readers' do
  it 'should be readable' do
    @mb_client = Mailgun::UnitClient.new("messages")
    @mb_obj = Mailgun::BatchMessage.new(@mb_client, "example.com")
    @mb_obj.should respond_to(:message_ids)
    @mb_obj.should respond_to(:message)
    @mb_obj.should respond_to(:counters)
    @mb_obj.should respond_to(:recipient_variables)
    @mb_obj.should respond_to(:domain)
  end
end

describe 'The instantiation of Batch Message' do

  before(:each) do
    @mb_client = Mailgun::UnitClient.new("messages")
    @mb_obj = Mailgun::BatchMessage.new(@mb_client, "example.com")
  end

  it 'contains Message, which should be of type Hash and empty' do
    @mb_obj.message.should be_a(Hash)
    @mb_obj.message.length.should eq(0)
  end

  it 'contains recipient_variables, which should be of type Hash and empty' do
    @mb_obj.recipient_variables.should be_a(Hash)
    @mb_obj.recipient_variables.length.should eq(0)
  end

  it 'contains domain, which should be of type string and contain example.com' do
    @mb_obj.domain.should be_a(String)
    @mb_obj.domain.should eq('example.com')
  end

  it 'contains message_ids, which should be of type hash and empty' do
    @mb_obj.message_ids.should be_a(Hash)
    @mb_obj.message_ids.length.should eq(0)
  end

  it 'contains counters, which should be of type hash and contain several important counters' do
    @mb_obj.counters.should be_a(Hash)
    @mb_obj.counters.should include(:recipients)
  end

  it 'contains counters, which should be of type hash and contain several important counters' do
    @mb_obj.counters.should be_a(Hash)

    @mb_obj.counters.should include(:recipients)
    @mb_obj.counters[:recipients].should include(:to)
    @mb_obj.counters[:recipients].should include(:cc)
    @mb_obj.counters[:recipients].should include(:bcc)

    @mb_obj.counters.should include(:attributes)
    @mb_obj.counters[:attributes].should include(:attachment)
    @mb_obj.counters[:attributes].should include(:campaign_id)
    @mb_obj.counters[:attributes].should include(:custom_option)
    @mb_obj.counters[:attributes].should include(:tag)
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
    @mb_obj.counters[:recipients][recipient_type].should eq(1000)
    @mb_obj.add_recipient(recipient_type, @address_1, @variables_1)
    @mb_obj.counters[:recipients][recipient_type].should eq(1)
  end

  it 'adds recipients to the message, calls finalize, and cleans up' do
    recipient_type = :to
    1000.times do
      @mb_obj.add_recipient(recipient_type, @address_1, @variables_1)
    end
    @mb_obj.counters[:recipients][recipient_type].should eq(1000)
    @mb_obj.finalize
    @mb_obj.message['recipient-variables'].length.should eq(0)
    @mb_obj.message[:to].length.should eq(0)
    @mb_obj.counters[:recipients][recipient_type].should eq(0)
  end

  it 'adds 5,005 recipients to the message body and validates we receive message_ids back' do
    recipient_type = :to
    5005.times do
      @mb_obj.add_recipient(recipient_type, @address_1, @variables_1)
    end
    @mb_obj.finalize
    @mb_obj.message_ids.length.should eq(6)
  end

  it 'sets recipient-variables, for batch expansion' do
    recipient_type = :to
    @mb_obj.add_recipient(recipient_type, @address_1, @variables_1)
    @mb_obj.recipient_variables[@address_1].should eq(@variables_1)
  end

  it 'sets multiple recipient-variables, for batch expansion' do
    recipient_type = :to
    @mb_obj.add_recipient(recipient_type, @address_1, @variables_1)
    @mb_obj.add_recipient(recipient_type, @address_2, @variables_2)
    @mb_obj.add_recipient(recipient_type, @address_3, @variables_3)
    @mb_obj.recipient_variables[@address_1].should eq(@variables_1)
    @mb_obj.recipient_variables[@address_2].should eq(@variables_2)
    @mb_obj.recipient_variables[@address_3].should eq(@variables_3)
  end

end
