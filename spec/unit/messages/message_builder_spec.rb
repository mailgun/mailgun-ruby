require 'spec_helper'

describe 'MessageBuilder attribute readers' do
  it 'should be readable' do
    @mb_obj = Mailgun::MessageBuilder.new()
    @mb_obj.should respond_to(:message)
    @mb_obj.should respond_to(:counters)
  end
end

describe 'The instantiation of MessageBuilder' do

  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new()
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
    @mb_obj = Mailgun::MessageBuilder.new
    @address = 'jane@example.com'
    @variables = {'first' => 'Jane', 'last' => 'Doe'}
  end

  it 'adds a "to" recipient type to the message body and counter is incremented' do
    recipient_type = :to
    @mb_obj.add_recipient(recipient_type, @address, @variables)
    @mb_obj.message[recipient_type][0].should eq("'#{@variables['first']} #{@variables['last']}' <#{@address}>")
    @mb_obj.counters[:recipients][recipient_type].should eq(1)
  end

  it 'adds a "cc" recipient type to the message body and counter is incremented' do
    recipient_type = :cc
    @mb_obj.add_recipient(recipient_type, @address, @variables)
    @mb_obj.message[recipient_type][0].should eq("'#{@variables['first']} #{@variables['last']}' <#{@address}>")
    @mb_obj.counters[:recipients][recipient_type].should eq(1)
  end

  it 'adds a "bcc" recipient type to the message body and counter is incremented' do
    recipient_type = :bcc
    @mb_obj.add_recipient(recipient_type, @address, @variables)
    @mb_obj.message[recipient_type][0].should eq("'#{@variables['first']} #{@variables['last']}' <#{@address}>")
    @mb_obj.counters[:recipients][recipient_type].should eq(1)
  end

  it 'adds a "h:reply-to" recipient type to the message body and counters are not incremented' do
    recipient_type = 'h:reply-to'
    @mb_obj.add_recipient(recipient_type, @address, @variables)
    @mb_obj.message[recipient_type][0].should eq("'#{@variables['first']} #{@variables['last']}' <#{@address}>")
    @mb_obj.counters[:recipients].each_value{|value| value.should eq(0)}
  end

  it 'ensures a random recipient type is added to the message body and counters are not incremented' do
    recipient_type = 'im-not-really-real'
    @mb_obj.add_recipient(recipient_type, @address, @variables)
    @mb_obj.message[recipient_type][0].should eq("'#{@variables['first']} #{@variables['last']}' <#{@address}>")
    @mb_obj.counters[:recipients].each_value{|value| value.should eq(0)}
  end
  it 'adds too many to recipients and raises an exception.' do
    recipient_type = :to
    expect{
      1001.times do
        @mb_obj.add_recipient(recipient_type, @address, @variables)
    end }.to raise_error(Mailgun::ParameterError)
  end
  it 'adds too many cc recipients and raises an exception.' do
    recipient_type = :cc
    expect{
      1001.times do
        @mb_obj.add_recipient(recipient_type, @address, @variables)
    end }.to raise_error(Mailgun::ParameterError)
  end
  it 'adds too many bcc recipients and raises an exception.' do
    recipient_type = :bcc
    expect{
      1001.times do
        @mb_obj.add_recipient(recipient_type, @address, @variables)
    end }.to raise_error(Mailgun::ParameterError)
  end
end

describe 'The method set_subject' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'sets the message subject to blank if called and no parameters are provided' do
    @mb_obj.set_subject
    @mb_obj.message[:subject][0].should eq('')
  end
  it 'sets the message subject if called with the subject parameter' do
    the_subject = 'This is my subject!'
    @mb_obj.set_subject(the_subject)
    @mb_obj.message[:subject][0].should eq(the_subject)
  end
  it 'ensures no duplicate subjects can exist and last setter is stored' do
    the_first_subject = 'This is my first subject!'
    the_second_subject = 'This is my second subject!'
    @mb_obj.set_subject(the_first_subject)
    @mb_obj.set_subject(the_second_subject)
    @mb_obj.message[:subject].length.should eq(1)
    @mb_obj.message[:subject][0].should eq(the_second_subject)
  end
end

describe 'The method set_text_body' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'sets the text_body to blank if called and no parameters are provided' do
    @mb_obj.set_text_body
    @mb_obj.message[:text] = ''
  end
  it 'sets the message text if called with the text_body parameter' do
    the_text = 'Don\'t mess with Texas!'
    @mb_obj.set_text_body(the_text)
    @mb_obj.message[:text] = the_text
  end
  it 'ensures no duplicate text bodies can exist and last setter is stored' do
    the_first_text = 'Mess with Texas!'
    the_second_text = 'Don\'t mess with Texas!'
    @mb_obj.set_text_body(the_first_text)
    @mb_obj.set_text_body(the_second_text)
    @mb_obj.message[:text].length.should eq(1)
    @mb_obj.message[:text][0].should eq(the_second_text)
  end
end

describe 'The method add_attachment' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'adds a few file paths to the message object' do

    file1 = File.dirname(__FILE__) + "/sample_data/mailgun_icon.png"
    file2 = File.dirname(__FILE__) + "/sample_data/rackspace_logo.jpg"

    file_paths = [file1, file2]

    file_paths.each {|item| @mb_obj.add_attachment(item)}
    @mb_obj.message[:attachment].length.should eq(2)
  end
end

describe 'The method add_inline_image' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'adds a few file paths to the message object' do
    file1 = File.dirname(__FILE__) + "/sample_data/mailgun_icon.png"
    file2 = File.dirname(__FILE__) + "/sample_data/rackspace_logo.jpg"

    file_paths = [file1, file2]

    file_paths.each {|item| @mb_obj.add_inline_image(item)}
    @mb_obj.message[:inline].length.should eq(2)
  end
end

describe 'The method set_test_mode' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'turns on test mode with boolean true' do
    @mb_obj.set_test_mode(true)
    @mb_obj.message["o:testmode"][0].should eq("yes")
  end
  it 'turns on test mode with string true' do
    @mb_obj.set_test_mode("true")
    @mb_obj.message["o:testmode"][0].should eq("yes")
  end
  it 'turns off test mode with boolean false' do
    @mb_obj.set_test_mode(false)
    @mb_obj.message["o:testmode"][0].should eq("no")
  end
  it 'turns off test mode with string false' do
    @mb_obj.set_test_mode("false")
    @mb_obj.message["o:testmode"][0].should eq("no")
  end
  it 'does not allow multiple values' do
    @mb_obj.set_test_mode("false")
    @mb_obj.set_test_mode("true")
    @mb_obj.set_test_mode("false")
    @mb_obj.message["o:testmode"].length.should eq(1)
    @mb_obj.message["o:testmode"][0].should eq("no")
  end
end

describe 'The method set_dkim' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'turns on dkim with boolean true' do
    @mb_obj.set_dkim(true)
    @mb_obj.message["o:dkim"][0].should eq("yes")
  end
  it 'turns on dkim with string true' do
    @mb_obj.set_dkim("true")
    @mb_obj.message["o:dkim"][0].should eq("yes")
  end
  it 'turns off dkim with boolean false' do
    @mb_obj.set_dkim(false)
    @mb_obj.message["o:dkim"][0].should eq("no")
  end
  it 'turns off dkim with string false' do
    @mb_obj.set_dkim("false")
    @mb_obj.message["o:dkim"][0].should eq("no")
  end
  it 'does not allow multiple values' do
    @mb_obj.set_dkim("false")
    @mb_obj.set_dkim("true")
    @mb_obj.set_dkim("false")
    @mb_obj.message["o:dkim"].length.should eq(1)
    @mb_obj.message["o:dkim"][0].should eq("no")
  end
end

describe 'The method add_campaign_id' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'adds a campaign ID to the message' do
    @mb_obj.add_campaign_id('My-Campaign-Id-1')
    @mb_obj.message["o:campaign"][0].should eq ("My-Campaign-Id-1")
  end
  it 'adds a few more campaign IDs to the message' do
    @mb_obj.add_campaign_id('My-Campaign-Id-1')
    @mb_obj.add_campaign_id('My-Campaign-Id-2')
    @mb_obj.add_campaign_id('My-Campaign-Id-3')
    @mb_obj.message["o:campaign"][0].should eq("My-Campaign-Id-1")
    @mb_obj.message["o:campaign"][1].should eq("My-Campaign-Id-2")
    @mb_obj.message["o:campaign"][2].should eq("My-Campaign-Id-3")
  end
  it 'adds too many campaign IDs to the message' do
    expect{
      10.times do
        @mb_obj.add_campaign_id('Test-Campaign-ID')
    end }.to raise_error(Mailgun::ParameterError)
  end
end

describe 'The method add_tag' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'adds a tag to the message' do
    @mb_obj.add_tag('My-Tag-1')
    @mb_obj.message["o:tag"][0].should eq("My-Tag-1")
  end
  it 'adds a few more tags to the message' do
    @mb_obj.add_tag('My-Tag-1')
    @mb_obj.add_tag('My-Tag-2')
    @mb_obj.add_tag('My-Tag-3')
    @mb_obj.message["o:tag"][0].should eq("My-Tag-1")
    @mb_obj.message["o:tag"][1].should eq("My-Tag-2")
    @mb_obj.message["o:tag"][2].should eq("My-Tag-3")
  end
  it 'adds too many tags to the message' do
    expect{
      10.times do
        @mb_obj.add_tag('My-Tag')
    end }.to raise_error(Mailgun::ParameterError)
  end
end

describe 'The method set_open_tracking' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'enables/disables open tracking on a per message basis.' do
    @mb_obj.set_open_tracking('Yes')
    @mb_obj.message["o:tracking-opens"][0].should eq("yes")
    @mb_obj.set_open_tracking('No')
    @mb_obj.message["o:tracking-opens"][0].should eq("no")
    @mb_obj.set_open_tracking(true)
    @mb_obj.message["o:tracking-opens"][0].should eq("yes")
    @mb_obj.set_open_tracking(false)
    @mb_obj.message["o:tracking-opens"][0].should eq("no")
  end
end

describe 'The method set_click_tracking' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'enables/disables click tracking on a per message basis.' do
    @mb_obj.set_click_tracking('Yes')
    @mb_obj.message["o:tracking-clicks"][0].should eq("yes")
    @mb_obj.set_click_tracking('No')
    @mb_obj.message["o:tracking-clicks"][0].should eq("no")
    @mb_obj.set_click_tracking(true)
    @mb_obj.message["o:tracking-clicks"][0].should eq("yes")
    @mb_obj.set_click_tracking(false)
    @mb_obj.message["o:tracking-clicks"][0].should eq("no")
    @mb_obj.set_click_tracking('html')
    @mb_obj.message["o:tracking-clicks"][0].should eq("html")
  end
end

describe 'The method set_delivery_time' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'defines a time/date to deliver a message in RFC2822 format.' do
    @mb_obj.set_delivery_time('October 25, 2013 10:00PM CST')
    @mb_obj.message["o:deliverytime"][0].should eq("Fri, 25 Oct 2013 22:00:00 -0600")
  end
end

describe 'The method set_custom_data' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'accepts valid JSON and appends as data to the message.' do
    @mb_obj.set_custom_data('my-data', '{"key":"value"}')
    @mb_obj.message["v:my-data"][0].should eq("{\"key\":\"value\"}")
  end
  it 'accepts a hash and appends as data to the message.' do
    data = {'key'=> 'value'}
    @mb_obj.set_custom_data('my-data', data)
    @mb_obj.message["v:my-data"][0].should eq("{\"key\":\"value\"}")
  end
  it 'throws an exception on broken JSON.' do
    data = 'This is some crappy JSON.'
    expect {@mb_obj.set_custom_data('my-data', data)}.to raise_error(Mailgun::ParameterError)
  end
end

describe 'The method add_custom_parameter' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'adds an undefined parameter to the message.' do
    @mb_obj.add_custom_parameter('h:my-sweet-header', 'datagoeshere')
    @mb_obj.message["h:my-sweet-header"][0].should eq("datagoeshere")
  end
end

describe 'The method set_message_id' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
    @the_message_id = '<20141014000000.11111.11111@example.com>'
  end
  it 'correctly sets the Message-Id header' do
    @mb_obj.set_message_id(@the_message_id)
    @mb_obj.message['h:Message-Id'].should eq(@the_message_id)
  end
  it 'correctly clears the Message-Id header when passed nil' do
    @mb_obj.set_message_id(nil)
    @mb_obj.message.has_key?('h:Message-Id').should eq(false)
  end
  it 'correctly sets the Message-Id header when passed an empty string' do
    @mb_obj.set_message_id(@the_message_id)
    @mb_obj.message.has_key?('h:Message-Id').should eq(true)
    @mb_obj.set_message_id('')
    @mb_obj.message.has_key?('h:Message-Id').should eq(false)
  end
end
