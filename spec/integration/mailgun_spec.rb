require 'spec_helper'
require 'mailgun'

describe 'Mailgun instantiation' do
  it 'instantiates an HttpClient object' do
    expect {@mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)}.not_to raise_error
  end
end

describe 'The method send_message()' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    random_number = rand(1 .. 5000000)
    @domain = "integration-test-#{random_number}.example.com"
    @mg_obj.post("domains", {:name => @domain})
  end

  it 'sends a standard message in test mode.' do
    result = @mg_obj.send_message(@domain, {:from => 'bob@domain.com',
                                            :to => 'sally@example.com',
                                            :subject => 'Hash Integration Test',
                                            :text => 'INTEGRATION TESTING',
                                            'o:testmode' => true})
    result.to_h!
    result.body.should include("message")
    result.body.should include("id")
  end

  it 'sends a message builder message in test mode.' do
    mb_obj = Mailgun::MessageBuilder.new()
    mb_obj.set_from_address("sender@example.com", {'first' => 'Sending', 'last' => 'User'})
    mb_obj.add_recipient(:to, "recipient@example.com", {'first' => 'Recipient', 'last' => 'User'})
    mb_obj.set_subject("Message Builder Integration Test")
    mb_obj.set_text_body("This is the text body.")
    mb_obj.set_test_mode(true)

    result = @mg_obj.send_message(@domain, mb_obj)

    result.to_h!
    result.body.should include("message")
    result.body.should include("id")
  end

  it 'sends a custom MIME message in test mode.' do
    mime_string = 'Delivered-To: mgbox01@gmail.com
Received: by luna.mailgun.net with HTTP; Tue, 26 Nov 2013 17:59:11 +0000
Mime-Version: 1.0
Content-Type: text/plain; charset="ascii"
Subject: Hello
From: Excited User <me@samples.mailgun.org>
To: sally@example.com
Message-Id: <20131126175911.25310.92289@samples.mailgun.org>
Content-Transfer-Encoding: 7bit
X-Mailgun-Sid: WyI2NTU4MSIsICJtZ2JveDAxQGdtYWlsLmNvbSIsICIxZmYiXQ==
Date: Tue, 26 Nov 2013 17:59:22 +0000
X-Mailgun-Drop-Message: yes
Sender: me@samples.mailgun.org

Testing some Mailgun awesomness!'

    message_params = {:to => 'sally@example.com',
                      :message => mime_string}

    result = @mg_obj.send_message(@domain, message_params)

    result.to_h!
    result.body.should include("message")
    result.body.should include("id")
  end

  after(:all) do
    @mg_obj.delete("domains/#{@domain}")
  end
end

describe 'For the domains endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    random_number = rand(1 .. 5000000)
    @domain = "integration-test-#{random_number}.example.com"
    @result = @mg_obj.post("domains", {:name => @domain,
                                       :smtp_password => 'super_secret',
                                       :spam_action => 'tag'})

    @result.to_h!
    @result.body.should include("domain")
    expect(@result.body["domain"]["name"]).to eq(@domain)
    expect(@result.body["domain"]["spam_action"]).to eq("tag")
    expect(@result.body["domain"]["smtp_password"]).to eq("super_secret")
  end

  it 'get the domain.' do
    result = @mg_obj.get("domains/#{@domain}")

    result.to_h!
    result.body.should include("domain")
    result.body["domain"]["name"].should eq(@domain)
  end

  it 'gets a list of domains.' do
    result = @mg_obj.get("domains")

    result.to_h!
    expect(result.body["total_count"]).to be > 0
  end

  it 'deletes a domain.' do
    result = @mg_obj.delete("domains/#{@domain}")

    result.to_h!
    expect(result.body["message"]).to eq("Domain has been deleted")
  end

  after(:all) do
    @mg_obj.delete("domains/#{@domain}")
  end
end

describe 'For the Unsubscribes endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    random_number = rand(1 .. 5000000)
    @domain = "integration-test-#{random_number}.example.com"
    @mg_obj.post("domains", {:name => @domain})
  end

  before(:each) do
    random_number = rand(1 .. 5000000)
    @email = "integration-test-#{random_number}@example.com"
    @result = @mg_obj.post("#{@domain}/unsubscribes",
                           {:address => @email,
                            :tag => '*'})

    @result.to_h!
    expect(@result.body["message"]).to eq("Address has been added to the unsubscribes table")
    expect(@result.body["address"]).to eq(@email)
  end

  it 'get an unsubscribee.' do
    result = @mg_obj.get("#{@domain}/unsubscribes/#{@email}")

    result.to_h!
    expect(result.body["total_count"]).to eq 1
    expect(result.body["items"][0]["address"]).to eq(@email)
  end

  it 'gets a list of unsubscribes.' do
    result = @mg_obj.get("#{@domain}/unsubscribes")

    result.to_h!
    expect(result.body["total_count"]).to be > 0
  end

  after(:each) do
    @mg_obj.delete("#{@domain}/unsubscribes/#{@email}")
  end

  after(:all) do
    @mg_obj.delete("domains/#{@domain}")
  end
end

describe 'For the Complaints endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    random_number = rand(1 .. 5000000)
    @domain = "integration-test-#{random_number}.example.com"
    @mg_obj.post("domains", {:name => @domain})
  end

  before(:each) do
    random_number = rand(1 .. 5000000)
    @email = "integration-test-#{random_number}@example.com"
    @result = @mg_obj.post("#{@domain}/complaints", {:address => @email})

    @result.to_h!
    expect(@result.body["message"]).to eq("Address has been added to the complaints table")
    expect(@result.body["address"]).to eq(@email)
  end

  it 'get a complaint.' do
    result = @mg_obj.get("#{@domain}/complaints/#{@email}")

    result.to_h!
    expect(result.body["complaint"]["count"]).to eq 1
    expect(result.body["complaint"]["address"]).to eq(@email)
  end

  it 'gets a list of complaints.' do
    result = @mg_obj.get("#{@domain}/complaints")

    result.to_h!
    expect(result.body["total_count"]).to be > 0
  end

  after(:each) do
    @mg_obj.delete("#{@domain}/complaints/#{@email}")
  end

  after(:all) do
    @mg_obj.delete("domains/#{@domain}")
  end
end

describe 'For the Bounces endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    random_number = rand(1 .. 5000000)
    @domain = "integration-test-#{random_number}.example.com"
    @mg_obj.post("domains", {:name => @domain})
  end

  before(:each) do
    random_number = rand(1 .. 5000000)
    @email = "integration-test-#{random_number}@example.com"
    @result = @mg_obj.post("#{@domain}/bounces",
                           {:address => @email,
                            :code => 550,
                            :error => "Integration Test"})

    @result.to_h!
    expect(@result.body["message"]).to eq("Address has been added to the bounces table")
    expect(@result.body["address"]).to eq(@email)
  end

  it 'get a bounce.' do
    result = @mg_obj.get("#{@domain}/bounces/#{@email}")

    result.to_h!
    expect(result.body["bounce"]["code"]).to eq("550")
    expect(result.body["bounce"]["address"]).to eq(@email)
    expect(result.body["bounce"]["error"]).to eq("Integration Test")
  end

  it 'gets a list of bounces.' do
    result = @mg_obj.get("#{@domain}/bounces")

    result.to_h!
    expect(result.body["total_count"]).to be > 0
  end

  after(:each) do
    @mg_obj.delete("#{@domain}/bounces/#{@email}")
  end

  after(:all) do
    @mg_obj.delete("domains/#{@domain}")
  end
end

describe 'For the Stats endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    random_number = rand(1 .. 5000000)
    @domain = "integration-test-#{random_number}.example.com"
    @mg_obj.post("domains", {:name => @domain})
  end

  it 'get some stats.' do
    @mg_obj.get("#{@domain}/stats", {:limit => 50, :skip => 10, :event => 'sent'})
  end

  after(:all) do
    @mg_obj.delete("domains/#{@domain}")
  end
end

describe 'For the Events endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    random_number = rand(1 .. 5000000)
    @domain = "integration-test-#{random_number}.example.com"
    @mg_obj.post("domains", {:name => @domain})
  end

  it 'get an event.' do
    result = @mg_obj.get("#{@domain}/events", {:limit => 1})

    result.to_h!
    expect(result.body["items"].length).to be_within(1).of(1)
    expect(result.body["paging"]).to include("next")
    expect(result.body["paging"]).to include("previous")
  end

  after(:all) do
    @mg_obj.delete("domains/#{@domain}")
  end
end

describe 'For the Routes endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
  end

  before(:each) do
    result = @mg_obj.post("routes",  {:priority => 10,
                                      :description => 'Integration Test Route',
                                      :expression => 'match_recipient(".*@example.com")',
                                      :action => 'forward("alice@example.com")'})

    result.to_h!
    expect(result.body["message"]).to eq("Route has been created")
    expect(result.body["route"]["description"]).to eq("Integration Test Route")
    expect(result.body["route"]["actions"]).to include('forward("alice@example.com")')
    expect(result.body["route"]["expression"]).to include('match_recipient(".*@example.com")')
    expect(result.body["route"]["priority"]).to eq(10)

    @route_id = result.body["route"]["id"]
  end

  it 'get the route.' do
    result = @mg_obj.get("routes/#{@route_id}")

    result.to_h!
    expect(result.body["route"]["description"]).to eq("Integration Test Route")
    expect(result.body["route"]["actions"]).to include('forward("alice@example.com")')
    expect(result.body["route"]["expression"]).to include('match_recipient(".*@example.com")')
    expect(result.body["route"]["priority"]).to eq(10)
  end

  it 'gets a list of all routes.' do
    result = @mg_obj.get("routes", {:limit => 50})

    result.to_h!
    expect(result.body["total_count"]).to be > 0
  end

  it 'updates the route.' do
    result = @mg_obj.put("routes/#{@route_id}",  {:priority => 10,
                                                  :description => 'Integration Test Route Update',
                                                  :expression => 'match_recipient(".*@example.com")',
                                                  :action => 'forward("update@example.com")'})

    result.to_h!
    expect(result.body["message"]).to eq("Route has been updated")
    expect(result.body["description"]).to eq("Integration Test Route Update")
    expect(result.body["actions"]).to include('forward("update@example.com")')
    expect(result.body["expression"]).to include('match_recipient(".*@example.com")')
    expect(result.body["priority"]).to eq(10)
  end

  after(:each) do
    @mg_obj.delete("routes/#{@route_id}")
  end
end

describe 'For the campaigns endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    random_number = rand(1 .. 5000000)
    @domain = "integration-test-#{random_number}.example.com"
    @mg_obj.post("domains", {:name => @domain})
  end

  before(:each) do
    random_number = rand(1 .. 5000000)
    @campaign_id = "integration_test_#{random_number}"
    result = @mg_obj.post("#{@domain}/campaigns", {:name => 'My Campaign',
                                                   :id => @campaign_id})

    result.to_h!
    expect(result.body["message"]).to eq("Campaign created")
    expect(result.body["campaign"]["id"]).to eq(@campaign_id)
    expect(result.body["campaign"]["name"]).to eq('My Campaign')
  end

  it 'get a campaign.' do
    result = @mg_obj.get("#{@domain}/campaigns/#{@campaign_id}")

    result.to_h!
    expect(result.body["id"]).to eq(@campaign_id)
    expect(result.body["name"]).to eq('My Campaign')
  end

  it 'gets a list of all campaigns.' do
    result = @mg_obj.get("#{@domain}/campaigns", {:limit => 50})

    result.to_h!
    expect(result.body["total_count"]).to be > 0
  end

  it 'update a campaign.' do
    result = @mg_obj.put("#{@domain}/campaigns/#{@campaign_id}", {:name => 'My Updated Campaign',
                                                                  :id => @campaign_id})

    result.to_h!
    expect(result.body["message"]).to eq("Campaign updated")
    expect(result.body["campaign"]["id"]).to eq(@campaign_id)
    expect(result.body["campaign"]["name"]).to eq('My Updated Campaign')
  end

  it 'get campaign events.' do
    expect{@mg_obj.get("#{@domain}/campaigns/#{@campaign_id}/events", {:groupby => "clicked"})}.not_to raise_error
  end

  it 'get campaign stats.' do
    expect{@mg_obj.get("#{@domain}/campaigns/#{@campaign_id}/stats", {:groupby => "domain"})}.not_to raise_error
  end

  after(:each) do
    @mg_obj.delete("#{@domain}/campaigns/#{@campaign_id}")
  end
  after(:all) do
    @mg_obj.delete("domains/#{@domain}")
  end
end

describe 'For the webhooks endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    random_number = rand(1 .. 5000000)
    @domain = "integration-test-#{random_number}.example.com"
    @mg_obj.post("domains", {:name => @domain})
  end

  before(:each) do
    random_number = rand(1 .. 5000000)
    @campaign_id = "integration_test_#{random_number}"
    result = @mg_obj.post("domains/#{@domain}/webhooks", {:id => 'bounce',
                                                          :url => 'http://example.com/mailgun/events/bounce'})

    result.to_h!
    expect(result.body["message"]).to eq("Webhook has been created")
    expect(result.body["webhook"]["url"]).to eq('http://example.com/mailgun/events/bounce')
  end

  it 'get a webhook.' do
    result = @mg_obj.get("domains/#{@domain}/webhooks/bounce")

    result.to_h!
    expect(result.body["webhook"]["url"]).to eq('http://example.com/mailgun/events/bounce')
  end

  it 'gets a list of all webhooks.' do
    result = @mg_obj.get("domains/#{@domain}/webhooks")

    result.to_h!
    expect(result.body["webhooks"]["bounce"]["url"]).to eq('http://example.com/mailgun/events/bounce')
  end

  it 'update a webhook.' do
    result = @mg_obj.put("domains/#{@domain}/webhooks/bounce", {:id => 'bounce',
                                                                :url => 'http://example.com/mailgun/events/new_bounce'})

    result.to_h!
    expect(result.body["message"]).to eq("Webhook has been updated")
    expect(result.body["webhook"]["url"]).to eq('http://example.com/mailgun/events/new_bounce')
  end

  after(:each) do
    @mg_obj.delete("domains/#{@domain}/webhooks/bounce")
  end

  after(:all) do
    @mg_obj.delete("domains/#{@domain}")
  end
end

describe 'For the Mailing Lists endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    random_number = rand(1 .. 5000000)
    @domain = "integration-test-#{random_number}.example.com"
    @mg_obj.post("domains", {:name => @domain})
  end

  before(:each) do
    random_number = rand(1 .. 5000000)
    @ml_address = "integration_test_#{random_number}@#{@domain}"
    result = @mg_obj.post("lists", {:address => @ml_address,
                                    :name => 'Integration Test List',
                                    :description => 'This list should be deleted automatically.',
                                    :access_level => 'members'})

    result.to_h!
    expect(result.body["message"]).to eq("Mailing list has been created")
    expect(result.body["list"]["address"]).to eq(@ml_address)
    expect(result.body["list"]["name"]).to eq('Integration Test List')
  end

  it 'get a list.' do
    result = @mg_obj.get("lists/#{@ml_address}")

    result.to_h!
    expect(result.body["list"]["address"]).to eq(@ml_address)
    expect(result.body["list"]["name"]).to eq('Integration Test List')
  end

  it 'gets a list of all lists.' do
    result = @mg_obj.get("lists", {:limit => 50})

    result.to_h!
    expect(result.body["total_count"]).to be > 0
  end

  it 'update a list.' do
    result = @mg_obj.put("lists/#{@ml_address}",
                         {:address => @ml_address,
                          :name => 'Integration Test List Update',
                          :description => 'This list should be deleted automatically.',
                          :access_level => 'readonly'})

    result.to_h!
    expect(result.body["message"]).to eq("Mailing list has been updated")
    expect(result.body["list"]["address"]).to eq(@ml_address)
    expect(result.body["list"]["name"]).to eq('Integration Test List Update')
    expect(result.body["list"]["access_level"]).to eq('readonly')
  end

  after(:each) do
    @mg_obj.delete("lists/#{@ml_address}")
  end

  after(:all) do
    @mg_obj.delete("domains/#{@domain}")
  end
end

describe 'For the Mailing Lists Members endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    random_number = rand(1 .. 5000000)
    @domain = "integration-test-#{random_number}.example.com"
    @ml_address = "integration_test_#{random_number}@#{@domain}"
    @ml_member = "integration_test_member_#{random_number}@#{@domain}"
    @mg_obj.post("domains", {:name => @domain})
    @mg_obj.post("lists", {:address => @ml_address,
                           :name => 'Integration Test List',
                           :description => 'This list should be deleted automatically.',
                           :access_level => 'members'})
  end

  before(:each) do
    result = @mg_obj.post("lists/#{@ml_address}/members",
                          {:address => @ml_member,
                           :name => 'Jane Doe',
                           :subscribed => true,
                           :upsert => 'no'})

    result.to_h!
    expect(result.body["message"]).to eq("Mailing list member has been created")
    expect(result.body["member"]["address"]).to eq(@ml_member)
    expect(result.body["member"]["name"]).to eq('Jane Doe')
  end

  it 'get a list member.' do
    result = @mg_obj.get("lists/#{@ml_address}/members/#{@ml_member}")

    result.to_h!
    expect(result.body["member"]["address"]).to eq(@ml_member)
    expect(result.body["member"]["name"]).to eq('Jane Doe')
  end

  it 'updates a list member.' do
    result = @mg_obj.put("lists/#{@ml_address}/members/#{@ml_member}",
                         {:name => 'Jane Doe Update',
                          :subscribed => false})

    result.to_h!
    expect(result.body["message"]).to eq("Mailing list member has been updated")
    expect(result.body["member"]["address"]).to eq(@ml_member)
    expect(result.body["member"]["name"]).to eq('Jane Doe Update')
    expect(result.body["member"]["subscribed"]).to eq(false)
  end

  after(:each) do
    @mg_obj.delete("lists/#{@ml_address}/members/#{@ml_member}")
  end

  after(:all) do
    @mg_obj.delete("domains/#{@domain}")
  end
end

describe 'For the Email Validation endpoint' do
  before(:all) do
    @mg_obj = Mailgun::Client.new(PUB_APIKEY)
  end

  it 'validates an address.' do
    result = @mg_obj.get("address/validate",
                         {:address => "test@example.com"})

    result.to_h!
    expect(result.body["is_valid"]).to eq(false)
    expect(result.body["address"]).to eq("test@example.com")
  end

  it 'parses an address.' do
    result = @mg_obj.get("address/parse",
                         {:addresses => "Alice <alice@example.com>,bob@example.com,example.com"})

    result.to_h!
    expect(result.body["parsed"]).to include("Alice <alice@example.com>")
    expect(result.body["parsed"]).to include("bob@example.com")
    expect(result.body["unparseable"]).to include("example.com")
  end
end
