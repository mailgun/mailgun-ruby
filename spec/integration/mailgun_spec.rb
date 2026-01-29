# frozen_string_literal: true

require 'spec_helper'
require 'mailgun'
require 'mailgun/exceptions/exceptions'

describe 'Mailgun instantiation', vcr: { cassette_name: 'instance' } do
  it 'instantiates an HttpClient object' do
    expect { @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL) }.not_to raise_error
  end
end

describe 'Client exceptions', vcr: { cassette_name: 'exceptions' } do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN || 'DOMAIN.TEST'
  end

  it 'display useful error information' do
    @mg_obj.send_message('not-our-doma.in', {
                           from: 'sally@not-our-doma.in',
                           to: "bob@#{@domain}",
                           subject: 'Exception Integration Test',
                           text: 'INTEGRATION TESTING'
                         })
  rescue Mailgun::CommunicationError => e
    expect(e.message).to include('404')
    expect(e.message).to include('Domain not found: not-our-doma.in')
  else
    raise
  end
end

describe 'Client exceptions', vcr: { cassette_name: 'exceptions-invalid-api-key' } do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN || 'DOMAIN.TEST'
  end

  it 'displays error information that API key is invalid' do
    @mg_obj.send_message(@domain, {
                           from: "sally@#{@domain}",
                           to: "sally@#{@domain}",
                           subject: 'Exception Integration Test',
                           text: 'INTEGRATION TESTING'
                         })
  rescue Mailgun::Unauthorized => e
    expect(e.message).to include('401')
    expect(e.message).to include('Invalid Domain or API key')
  else
    raise
  end
end

describe 'Client exceptions', vcr: { cassette_name: 'exceptions-invalid-data' } do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN || 'DOMAIN.TEST'
  end

  it 'display useful error information' do
    @mg_obj.send_message(@domain, {
                           from: "sally@#{@domain}",
                           to: "sally#{@domain}",
                           subject: 'Exception Integration Test',
                           text: 'INTEGRATION TESTING'
                         })
  rescue Mailgun::BadRequest => e
    expect(e.message).to include('400')
    expect(e.message).to include('to parameter is not a valid address. please check documentation')
  else
    raise
  end
end

describe 'Client exceptions', vcr: { cassette_name: 'exceptions-not-allowed' } do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN || 'DOMAIN.TEST'
  end

  it 'display useful error information' do
    @mg_obj.send_message(@domain, {
                           from: "invalid@#{@domain}",
                           to: "invalid#{@domain}",
                           subject: 'Exception Integration Test',
                           text: 'INTEGRATION TESTING'
                         })
  rescue Mailgun::CommunicationError => e
    expect(e.message).to include('403')
  else
    raise
  end
end

describe 'The method send_message()', vcr: { cassette_name: 'send_message' } do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN || 'DOMAIN.TEST'
  end

  it 'sends a standard message in test mode.' do
    @mg_obj.enable_test_mode!
    result = @mg_obj.send_message(@domain, { :from => "bob@#{@domain}",
                                             :to => "sally@#{@domain}",
                                             :subject => 'Hash Integration Test',
                                             :text => 'INTEGRATION TESTING',
                                             'o:testmode' => true })
    result.to_h!
    expect(result.body).to include('message')
    expect(result.body).to include('id')
  end

  it 'fakes message send while in *client* test mode' do
    @mg_obj.enable_test_mode!

    expect(@mg_obj.test_mode?).to eq(true)

    data = { from: "joe@#{@domain}",
             to: "bob@#{@domain}",
             subject: 'Test',
             text: 'Test Data' }
    uuid = 'uuid'

    allow(SecureRandom).to receive(:uuid).and_return(uuid)

    result = @mg_obj.send_message(@domain, data)

    result.to_h!

    expect(result.body).to include('message')
    expect(result.body).to include('id')

    expect(result.code).to eq(200)
    expect(result.body['id']).to eq("test-mode-mail-#{uuid}@localhost")
    expect(result.body['message']).to eq('Queued. Thank you.')
  end

  it 'sends a message builder message in test mode.' do
    mb_obj = Mailgun::MessageBuilder.new
    mb_obj.from("sender@#{@domain}", { 'first' => 'Sending', 'last' => 'User' })
    mb_obj.add_recipient(:to, "recipient@#{@domain}", { 'first' => 'Recipient', 'last' => 'User' })
    mb_obj.subject('Message Builder Integration Test')
    mb_obj.body_text('This is the text body.')
    mb_obj.test_mode(true)

    result = @mg_obj.send_message(@domain, mb_obj)

    result.to_h!
    expect(result.body).to include('message')
    expect(result.body).to include('id')
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

    message_params = { from: "bobby@#{@domain}",
                       to: "sally@#{@domain}",
                       message: mime_string }

    result = @mg_obj.send_message(@domain, message_params)

    result.to_h!
    expect(result.body).to include('message')
    expect(result.body).to include('id')
  end

  it 'receives success response code' do
    @mg_obj.enable_test_mode!

    expect(@mg_obj.test_mode?).to eq(true)

    data = { from: "joe@#{@domain}",
             to: "bob@#{@domain}",
             subject: 'Test',
             text: 'Test Data' }

    result = @mg_obj.send_message(@domain, data)
    result.to_h!

    expect(result.success?).to be(true)
  end
end
