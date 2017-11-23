require 'spec_helper'
require 'stringio'

describe 'MessageBuilder attribute readers' do
  it 'should be readable' do
    @mb_obj = Mailgun::MessageBuilder.new()

    expect(@mb_obj).to respond_to(:message)
    expect(@mb_obj).to respond_to(:counters)
  end
end

describe 'The instantiation of MessageBuilder' do

  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new()
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
    @mb_obj = Mailgun::MessageBuilder.new
    @address = 'jane@example.com'
    @variables = {'first' => 'Jane', 'last' => 'Doe'}
  end

  it 'adds a "to" recipient type to the message body and counter is incremented' do
    recipient_type = :to
    @mb_obj.add_recipient(recipient_type, @address, @variables)

    expect(@mb_obj.message[recipient_type][0]).to eq("'#{@variables['first']} #{@variables['last']}' <#{@address}>")
    expect(@mb_obj.counters[:recipients][recipient_type]).to eq(1)
  end

  it 'adds a "cc" recipient type to the message body and counter is incremented' do
    recipient_type = :cc
    @mb_obj.add_recipient(recipient_type, @address, @variables)

    expect(@mb_obj.message[recipient_type][0]).to eq("'#{@variables['first']} #{@variables['last']}' <#{@address}>")
    expect(@mb_obj.counters[:recipients][recipient_type]).to eq(1)
  end

  it 'adds a "bcc" recipient type to the message body and counter is incremented' do
    recipient_type = :bcc
    @mb_obj.add_recipient(recipient_type, @address, @variables)

    expect(@mb_obj.message[recipient_type][0]).to eq("'#{@variables['first']} #{@variables['last']}' <#{@address}>")
    expect(@mb_obj.counters[:recipients][recipient_type]).to eq(1)
  end

  it 'adds a "h:reply-to" recipient type to the message body and counters are not incremented' do
    recipient_type = 'h:reply-to'
    @mb_obj.add_recipient(recipient_type, @address, @variables)

    expect(@mb_obj.message[recipient_type]).to eq("'#{@variables['first']} #{@variables['last']}' <#{@address}>")
    @mb_obj.counters[:recipients].each_value{|value| expect(value).to eq(0)}
  end

  it 'ensures a random recipient type is added to the message body and counters are not incremented' do
    recipient_type = 'im-not-really-real'
    @mb_obj.add_recipient(recipient_type, @address, @variables)

    expect(@mb_obj.message[recipient_type][0]).to eq("'#{@variables['first']} #{@variables['last']}' <#{@address}>")
    @mb_obj.counters[:recipients].each_value{|value| expect(value).to eq(0)}
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
  it 'warns of set_subject deprecation' do
    @mb_obj = Mailgun::MessageBuilder.new
    expect(@mb_obj).to receive :warn
    @mb_obj.set_subject 'warn on set_subject'
  end
end

describe 'The method subject' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end

  it 'sets the message subject to blank if called and no parameters are provided' do
    @mb_obj.subject

    expect(@mb_obj.message[:subject][0]).to eq('')
  end

  it 'sets the message subject if called with the subject parameter' do
    the_subject = 'This is my subject!'
    @mb_obj.subject(the_subject)

    expect(@mb_obj.message[:subject][0]).to eq(the_subject)
  end

  it 'ensures no duplicate subjects can exist and last setter is stored' do
    the_first_subject = 'This is my first subject!'
    the_second_subject = 'This is my second subject!'
    @mb_obj.subject(the_first_subject)
    @mb_obj.subject(the_second_subject)

    expect(@mb_obj.message[:subject].length).to eq(1)
    expect(@mb_obj.message[:subject][0]).to eq(the_second_subject)
  end
end

describe 'The method set_text_body' do
  it 'warns of set_text_body deprecation' do
    @mb_obj = Mailgun::MessageBuilder.new
    expect(@mb_obj).to receive :warn
    @mb_obj.set_text_body 'warn on set_text_body'
  end
end

describe 'The method body_text' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'sets the body_text to blank if called and no parameters are provided' do
    @mb_obj.body_text
    @mb_obj.message[:text] = ''
  end
  it 'sets the message text if called with the body_text parameter' do
    the_text = 'Don\'t mess with Texas!'
    @mb_obj.body_text(the_text)
    @mb_obj.message[:text] = the_text
  end
  it 'ensures no duplicate text bodies can exist and last setter is stored' do
    the_first_text = 'Mess with Texas!'
    the_second_text = 'Don\'t mess with Texas!'
    @mb_obj.body_text(the_first_text)
    @mb_obj.body_text(the_second_text)

    expect(@mb_obj.message[:text].length).to eq(1)
    expect(@mb_obj.message[:text][0]).to eq(the_second_text)
  end
end

describe 'The method set_from_address' do
  it 'warns of set_from_address deprecation' do
    @mb_obj = Mailgun::MessageBuilder.new
    expect(@mb_obj).to receive :warn
    @mb_obj.set_from_address 'warn on set_from_address'
  end
end

describe 'The method from' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end

  it 'sets the from address' do
    the_from_address = 'test@mailgun.com'
    @mb_obj.from(the_from_address)

    expect(@mb_obj.message[:from]).to eq([the_from_address])
  end

  it 'sets the from address with first/last metadata' do
    the_from_address = 'test@mailgun.com'
    the_first_name = 'Magilla'
    the_last_name = 'Gorilla'
    @mb_obj.from(the_from_address, {'first' => the_first_name, 'last' => the_last_name})

    expect(@mb_obj.message[:from]).to eq(["'#{the_first_name} #{the_last_name}' <#{the_from_address}>"])
  end

  it 'sets the from address with full name metadata' do
    the_from_address = 'test@mailgun.com'
    full_name = 'Magilla Gorilla'
    @mb_obj.from(the_from_address, {'full_name' => full_name})

    expect(@mb_obj.message[:from]).to eq(["'#{full_name}' <#{the_from_address}>"])
  end

  it 'fails when first/last and full_name are used' do
    the_from_address = 'test@mailgun.com'
    full_name = 'Magilla Gorilla'
    first_name = 'Magilla'
    expect{@mb_obj.from(the_from_address, {'full_name' => full_name, 'first' => first_name})}.to raise_error(Mailgun::ParameterError)
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

    expect(@mb_obj.message[:attachment].length).to eq(2)
  end

  it 'adds file-like objects to the message object' do
    io = StringIO.new
    io << File.binread(File.dirname(__FILE__) + "/sample_data/mailgun_icon.png")

    @mb_obj.add_attachment io, 'mailgun_icon.png'

    expect(@mb_obj.message[:attachment].length).to eq(1)
    expect(@mb_obj.message[:attachment].first.original_filename).to eq 'mailgun_icon.png'
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

    expect(@mb_obj.message[:inline].length).to eq(2)
  end
end

describe 'The method list_unsubscribe' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end

  it 'sets the message list_unsubscribe to blank if called and no parameters are provided' do
    @mb_obj.list_unsubscribe
    expect(@mb_obj.message['h:List-Unsubscribe']).to eq('')
  end

  it 'sets the message list_unsubscribe if called with one list_unsubscribe parameter' do
    unsubscribe_to = 'http://example.com/stop-hassle'
    @mb_obj.list_unsubscribe(unsubscribe_to)
    expect(@mb_obj.message['h:List-Unsubscribe']).to eq("<#{unsubscribe_to}>")
  end

  it 'sets the message list_unsubscribe if called with many list_unsubscribe parameters' do
    unsubscribe_to = %w(http://example.com/stop-hassle mailto:stop-hassle@example.com)
    @mb_obj.list_unsubscribe(*unsubscribe_to)
    expect(@mb_obj.message['h:List-Unsubscribe']).to eq(
      unsubscribe_to.map { |var| "<#{var}>" }.join(',')
    )
  end
end

describe 'The method set_test_mode' do
  it 'warns of set_test_mode deprecation' do
    @mb_obj = Mailgun::MessageBuilder.new
    expect(@mb_obj).to receive :warn
    @mb_obj.set_test_mode 'warn on set_test_mode'
  end
end

describe 'The method test_mode' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'turns on test mode with boolean true' do
    @mb_obj.test_mode(true)

    expect(@mb_obj.message["o:testmode"][0]).to eq("yes")
  end
  it 'turns on test mode with string true' do
    @mb_obj.test_mode("true")

    expect(@mb_obj.message["o:testmode"][0]).to eq("yes")
  end
  it 'turns off test mode with boolean false' do
    @mb_obj.test_mode(false)

    expect(@mb_obj.message["o:testmode"][0]).to eq("no")
  end
  it 'turns off test mode with string false' do
    @mb_obj.test_mode("false")

    expect(@mb_obj.message["o:testmode"][0]).to eq("no")
  end
  it 'does not allow multiple values' do
    @mb_obj.test_mode("false")
    @mb_obj.test_mode("true")
    @mb_obj.test_mode("false")

    expect(@mb_obj.message["o:testmode"].length).to eq(1)
    expect(@mb_obj.message["o:testmode"][0]).to eq("no")
  end
end

describe 'The method set_dkim' do
  it 'warns of set_dkim deprecation' do
    @mb_obj = Mailgun::MessageBuilder.new
    expect(@mb_obj).to receive :warn
    @mb_obj.set_dkim 'warn on set_dkim'
  end
end

describe 'The method dkim' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'turns on dkim with boolean true' do
    @mb_obj.dkim(true)

    expect(@mb_obj.message["o:dkim"][0]).to eq("yes")
  end
  it 'turns on dkim with string true' do
    @mb_obj.dkim("true")

    expect(@mb_obj.message["o:dkim"][0]).to eq("yes")
  end
  it 'turns off dkim with boolean false' do
    @mb_obj.dkim(false)

    expect(@mb_obj.message["o:dkim"][0]).to eq("no")
  end
  it 'turns off dkim with string false' do
    @mb_obj.dkim("false")

    expect(@mb_obj.message["o:dkim"][0]).to eq("no")
  end
  it 'does not allow multiple values' do
    @mb_obj.dkim("false")
    @mb_obj.dkim("true")
    @mb_obj.dkim("false")

    expect(@mb_obj.message["o:dkim"].length).to eq(1)
    expect(@mb_obj.message["o:dkim"][0]).to eq("no")
  end
end

describe 'The method add_campaign_id' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'adds a campaign ID to the message' do
    @mb_obj.add_campaign_id('My-Campaign-Id-1')

    expect(@mb_obj.message["o:campaign"][0]).to eq ("My-Campaign-Id-1")
  end
  it 'adds a few more campaign IDs to the message' do
    @mb_obj.add_campaign_id('My-Campaign-Id-1')
    @mb_obj.add_campaign_id('My-Campaign-Id-2')
    @mb_obj.add_campaign_id('My-Campaign-Id-3')

    expect(@mb_obj.message["o:campaign"][0]).to eq("My-Campaign-Id-1")
    expect(@mb_obj.message["o:campaign"][1]).to eq("My-Campaign-Id-2")
    expect(@mb_obj.message["o:campaign"][2]).to eq("My-Campaign-Id-3")
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

    expect(@mb_obj.message["o:tag"][0]).to eq("My-Tag-1")
  end
  it 'adds a few more tags to the message' do
    @mb_obj.add_tag('My-Tag-1')
    @mb_obj.add_tag('My-Tag-2')
    @mb_obj.add_tag('My-Tag-3')

    expect(@mb_obj.message["o:tag"][0]).to eq("My-Tag-1")
    expect(@mb_obj.message["o:tag"][1]).to eq("My-Tag-2")
    expect(@mb_obj.message["o:tag"][2]).to eq("My-Tag-3")
  end
  it 'adds too many tags to the message' do
    expect{
      10.times do
        @mb_obj.add_tag('My-Tag')
    end }.to raise_error(Mailgun::ParameterError)
  end
end

describe 'The method set_open_tracking' do
  it 'warns of set_open_tracking deprecation' do
    @mb_obj = Mailgun::MessageBuilder.new
    expect(@mb_obj).to receive :warn
    @mb_obj.set_open_tracking 'warn on set_open_tracking'
  end
end

describe 'The method track_opens' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'enables/disables open tracking on a per message basis.' do
    @mb_obj.track_opens('Yes')

    expect(@mb_obj.message["o:tracking-opens"][0]).to eq("yes")

    @mb_obj.track_opens('No')

    expect(@mb_obj.message["o:tracking-opens"][0]).to eq("no")

    @mb_obj.track_opens(true)

    expect(@mb_obj.message["o:tracking-opens"][0]).to eq("yes")

    @mb_obj.track_opens(false)

    expect(@mb_obj.message["o:tracking-opens"][0]).to eq("no")
  end
end

describe 'The method set_click_tracking' do
  it 'warns of set_click_tracking deprecation' do
    @mb_obj = Mailgun::MessageBuilder.new
    expect(@mb_obj).to receive :warn
    @mb_obj.set_click_tracking 'warn on set_click_tracking'
  end
end

describe 'The method track_clicks' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'enables/disables click tracking on a per message basis.' do
    @mb_obj.track_clicks('Yes')

    expect(@mb_obj.message["o:tracking-clicks"][0]).to eq("yes")

    @mb_obj.track_clicks('No')

    expect(@mb_obj.message["o:tracking-clicks"][0]).to eq("no")

    @mb_obj.track_clicks(true)

    expect(@mb_obj.message["o:tracking-clicks"][0]).to eq("yes")

    @mb_obj.track_clicks(false)

    expect(@mb_obj.message["o:tracking-clicks"][0]).to eq("no")

    @mb_obj.track_clicks('html')

    expect(@mb_obj.message["o:tracking-clicks"][0]).to eq("html")
  end
end

describe 'The method set_delivery_time' do
  it 'warns of set_delivery_time deprecation' do
    @mb_obj = Mailgun::MessageBuilder.new
    expect(@mb_obj).to receive :warn
    @mb_obj.set_delivery_time 'October 25, 2013 10:00PM CST'
  end
end

describe 'The method deliver_at' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'defines a time/date to deliver a message in RFC2822 format.' do
    @mb_obj.deliver_at('October 25, 2013 10:00PM CST')

    expect(@mb_obj.message["o:deliverytime"][0]).to eq("Fri, 25 Oct 2013 22:00:00 -0600")
  end
end

describe 'The method set_custom_data' do
  it 'warns of set_custom_data deprecation' do
    @mb_obj = Mailgun::MessageBuilder.new
    expect(@mb_obj).to receive :warn
    @mb_obj.set_custom_data 'my-data', '{"key":"value"}'
  end
end

describe 'The method header' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'accepts valid JSON and appends as data to the message.' do
    @mb_obj.header('my-data', '{"key":"value"}')

    expect(@mb_obj.message["h:my-data"]).to be_kind_of(String)
    expect(@mb_obj.message["h:my-data"].to_s).to eq('{"key":"value"}')
  end
end

describe 'The method variable' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'accepts valid JSON and stores it as message[param].' do
    @mb_obj.variable('my-data', '{"key":"value"}')

    expect(@mb_obj.message["v:my-data"]).to be_kind_of(String)
    expect(@mb_obj.message["v:my-data"].to_s).to eq('{"key":"value"}')
  end
  it 'accepts a hash and appends as data to the message.' do
    data = {'key' => 'value'}
    @mb_obj.variable('my-data', data)

    expect(@mb_obj.message["v:my-data"]).to be_kind_of(String)
    expect(@mb_obj.message["v:my-data"].to_s).to eq('{"key":"value"}')
  end
  it 'throws an exception on broken JSON.' do
    data = 'This is some crappy JSON.'
    expect {@mb_obj.variable('my-data', data)}.to raise_error(Mailgun::ParameterError)
  end
end

describe 'The method add_custom_parameter' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
  end
  it 'adds an undefined parameter to the message.' do
    @mb_obj.add_custom_parameter('h:my-sweet-header', 'datagoeshere')

    expect(@mb_obj.message["h:my-sweet-header"][0]).to eq("datagoeshere")
  end
end

describe 'The method set_message_id' do
  it 'warns of set_message_id deprecation' do
    @mb_obj = Mailgun::MessageBuilder.new
    expect(@mb_obj).to receive :warn
    @mb_obj.set_message_id 'warn on set_message_id'
  end
end

describe 'The method message_id' do
  before(:each) do
    @mb_obj = Mailgun::MessageBuilder.new
    @the_message_id = '<20141014000000.11111.11111@example.com>'
  end
  it 'correctly sets the Message-Id header' do
    @mb_obj.message_id(@the_message_id)

    expect(@mb_obj.message['h:Message-Id']).to eq(@the_message_id)
  end
  it 'correctly clears the Message-Id header when passed nil' do
    @mb_obj.message_id(nil)

    expect(@mb_obj.message.has_key?('h:Message-Id')).to eq(false)
  end
  it 'correctly sets the Message-Id header when passed an empty string' do
    @mb_obj.message_id(@the_message_id)

    expect(@mb_obj.message.has_key?('h:Message-Id')).to eq(true)

    @mb_obj.message_id('')

    expect(@mb_obj.message.has_key?('h:Message-Id')).to eq(false)
  end
end
