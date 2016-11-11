require 'spec_helper'

describe 'Mailgun instantiation' do
  it 'instantiates an HttpClient object' do
    expect {@mg_obj = Mailgun::UnitClient.new("messages")}.not_to raise_error
  end
end

describe 'The method send_message()' do
  before(:each) do
    @mg_obj = Mailgun::UnitClient.new("messages")
    @domain = "test.com"
    @list_address = "mylist@test.com"
    @member_address = "subscribee@test.com"
  end

  it 'accepts only specific data types' do
    @mb_obj = Mailgun::MessageBuilder.new()
    @mh_obj = {}

    expect {@mg_obj.send_message("test.com", "incorrect data")}.to raise_error Mailgun::ParameterError
    expect {@mg_obj.send_message("test.com", @mb_obj)}.not_to raise_error
    expect {@mg_obj.send_message("test.com", @mh_obj)}.not_to raise_error
  end

  it 'sends a message' do
    data = { 'from' => 'joe@test.com',
             'to' => 'bob@example.com',
             'subject' => 'Test',
             'text' => 'Test Data' }
    result = @mg_obj.send_message("testdomain.com", data)

    result.to_h!

    expect(result.body).to include("message")
    expect(result.body).to include("id")
  end

  it 'opens the message MIME and sends the MIME message.' do
    data = {'to' => 'joe@test.com',
                    'message' => 'Sample Data/mime.txt'}
    result = @mg_obj.send_message("testdomain.com", data)

    result.to_h!

    expect(result.body).to include("message")
    expect(result.body).to include("id")
  end
end

describe 'The method post()' do
  before(:each) do
    @mg_obj = Mailgun::UnitClient.new("messages")
    @domain = "test.com"
  end
  it 'in this case, sends a simple message.' do
    data = {'from' => 'joe@test.com',
                    'to' => 'bob@example.com',
                    'subject' => 'Test',
                    'text' => 'Test Data'}
    result = @mg_obj.post("#{@domain}/messages", data)

    result.to_h!

    expect(result.body).to include("message")
    expect(result.body).to include("id")
  end
end

describe 'The method put()' do
  before(:each) do
    @mg_obj = Mailgun::UnitClient.new("lists")
    @domain = "test.com"
    @list_address = "mylist@test.com"
    @member_address = "subscribee@test.com"
  end

  it 'in this case, updates a member with the attributes in data.' do
    data = {'subscribed' => false,
                    'name' => 'Foo Bar'}
    result = @mg_obj.put("lists/#{@list_address}/members#{@member_address}", data)

    result.to_h!

    expect(result.body).to include("member")
    expect(result.body["member"]).to include("vars")
    expect(result.body["member"]["vars"]).to include("age")
    expect(result.body["member"]).to include("name")
    expect(result.body["member"]).to include("subscribed")
    expect(result.body["member"]).to include("address")
    expect(result.body).to include("message")
  end

end

describe 'The method get()' do
  before(:each) do
    @mg_obj = Mailgun::UnitClient.new("bounces")
    @domain = "test.com"
  end
  it 'in this case, obtains a list of bounces for the domain, limit of 5, skipping the first 10.' do
    query_string = {'skip' => '10',
                    'limit' => '5'}
    result = @mg_obj.get("#{@domain}/bounces", query_string)

    result.to_h!

    expect(result.body).to include("total_count")
    expect(result.body).to include("items")
  end
end

describe 'The method delete()' do
  before(:each) do
    @mg_obj = Mailgun::UnitClient.new("campaigns")
    @domain = "test.com"
  end

  it 'issues a generic delete request.' do
    result = @mg_obj.delete("#{@domain}/campaigns/ABC123")

    result.to_h!

    expect(result.body).to include("message")
    expect(result.body).to include("id")
  end
end
