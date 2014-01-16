require 'spec_helper'

module Mailgun
  class Client
    def initialize(api_key, api_host="api.mailgun.net", api_version="v2")
      @http_client = Mailgun::UnitClient::new(api_key, api_host, api_version)
    end
  end
end

describe 'Mailgun instantiation' do
  it 'instantiates an HttpClient object' do
    expect {@mg_obj = Mailgun::Client.new("Fake-API-Key")}.not_to raise_error
  end
end

describe 'The method send_message()' do
  before(:each) do
    @mg_obj = Mailgun::Client.new("Fake-API-Key")
    @domain = "test.com"
    @list_address = "mylist@test.com"
    @member_address = "subscribee@test.com"
  end

  it 'accepts only specific data types' do
    @mb_obj = Mailgun::MessageBuilder.new()
    @mm_obj = Multimap.new()
    @mh_obj = {}

    expect {@mg_obj.send_message("test.com", "incorrect data")}.to raise_error
    expect {@mg_obj.send_message("test.com", @mb_obj)}.not_to raise_error
    expect {@mg_obj.send_message("test.com", @mm_obj)}.not_to raise_error
    expect {@mg_obj.send_message("test.com", @mh_obj)}.not_to raise_error
  end

  it 'sends a message' do
    data = {'from' => 'joe@test.com',
                    'to' => 'bob@example.com',
                    'subject' => 'Test',
                    'text' => 'Test Data'}
    result = @mg_obj.send_message("testdomain.com", data)

    result.to_hash!
    result.body.should include("message")
    result.body.should include("id")
  end

  it 'opens the message MIME and sends the MIME message.' do
    data = {'to' => 'joe@test.com',
                    'message' => 'Sample Data/mime.txt'}
    result = @mg_obj.send_message("testdomain.com", data)

    result.to_hash!
    result.body.should include("message")
    result.body.should include("id")
  end
end

describe 'The method post()' do
  before(:each) do
    @mg_obj = Mailgun::Client.new("Fake-API-Key")
    @domain = "test.com"
  end
  it 'in this case, sends a simple message.' do
    data = {'from' => 'joe@test.com',
                    'to' => 'bob@example.com',
                    'subject' => 'Test',
                    'text' => 'Test Data'}
    result = @mg_obj.post("#{@domain}/messages", data)

    result.to_hash!
    result.body.should include("message")
    result.body.should include("id")
  end
end

describe 'The method put()' do
  before(:each) do
    @mg_obj = Mailgun::Client.new("Fake-API-Key")
    @domain = "test.com"
    @list_address = "mylist@test.com"
    @member_address = "subscribee@test.com"
  end

  it 'in this case, updates a member with the attributes in data.' do
    data = {'subscribed' => false,
                    'name' => 'Foo Bar'}
    result = @mg_obj.put("lists/#{@list_address}/members#{@member_address}", data)

    result.to_hash!
    result.body.should include("member")
    result.body["member"].should include("vars")
    result.body["member"]["vars"].should include("age")
    result.body["member"].should include("name")
    result.body["member"].should include("subscribed")
    result.body["member"].should include("address")
    result.body.should include("message")
  end

end

describe 'The method get()' do
  before(:each) do
    @mg_obj = Mailgun::Client.new("Fake-API-Key")
    @domain = "test.com"
  end
  it 'in this case, obtains a list of bounces for the domain, limit of 5, skipping the first 10.' do
    query_string = {'skip' => '10',
                    'limit' => '5'}
    result = @mg_obj.get("#{@domain}/bounces", query_string)

    result.to_hash!
    result.body.should include("total_count")
    result.body.should include("items")
  end
end

describe 'The method delete()' do
  before(:each) do
    @mg_obj = Mailgun::Client.new("Fake-API-Key")
    @domain = "test.com"
  end

  it 'issues a generic delete request.' do
    result = @mg_obj.delete("#{@domain}/campaigns/ABC123")

    result.to_hash!
    result.body.should include("message")
    result.body.should include("id")
  end
end
