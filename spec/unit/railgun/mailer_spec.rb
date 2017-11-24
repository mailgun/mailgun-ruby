require 'json'
require 'logger'
require 'spec_helper'
require 'mailgun'
require 'railgun'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :test
Rails.logger = Logger.new('/dev/null')
Rails.logger.level = Logger::DEBUG

class UnitTestMailer < ActionMailer::Base
  default from: 'unittest@example.org'

  def plain_message(address, subject, headers)
    headers(headers)
    mail(to: address, subject: subject) do |format|
      format.text { render plain: "Test!" }
      format.html { render html: "<p>Test!</p>".html_safe }
    end
  end

  def message_with_attachment(address, subject)
    attachments['info.txt'] = {
      :content => File.read('docs/railgun/Overview.md'),
      :mime_type => 'text/plain',
    }
    mail(to: address, subject: subject) do |format|
      format.text { render plain: "Test!" }
      format.html { render html: "<p>Test!</p>".html_safe }
    end
  end

end

describe 'Railgun::Mailer' do

  it 'has a mailgun_client property which returns a Mailgun::Client' do
    config = {
      api_key:  {},
      domain:   {}
    }
    @mailer_obj = Railgun::Mailer.new(config)

    expect(@mailer_obj.mailgun_client).to be_a(Mailgun::Client)
  end

  it 'properly creates a message body' do
    message = UnitTestMailer.plain_message('test@example.org', 'Test!', {})
    body = Railgun.transform_for_mailgun(message)

    [:from, :subject, :text, :html, 'to'].each do |param|
      expect(body).to include(param)
    end

    expect(body[:from][0].value).to eq('unittest@example.org')
    expect(body['to']).to eq(['test@example.org'])
    expect(body[:subject]).to eq(['Test!'])
    expect(body[:text]).to eq(['Test!'])
    expect(body[:html]).to eq(['<p>Test!</p>'.html_safe])
  end

  it 'adds options to message body' do
    message = UnitTestMailer.plain_message('test@example.org', '', {})
    message.mailgun_options ||= {
      'tracking-opens' => 'true',
    }

    body = Railgun.transform_for_mailgun(message)

    expect(body).to include('o:tracking-opens')
    expect(body['o:tracking-opens']).to eq('true')
  end

  it 'adds variables to message body' do
    message = UnitTestMailer.plain_message('test@example.org', '', {})
    message.mailgun_variables ||= {
      'user' => {:id => '1', :name => 'tstark'},
    }

    body = Railgun.transform_for_mailgun(message)

    expect(body).to include('v:user')

    var_body = JSON.load(body['v:user'])
    expect(var_body).to include('id')
    expect(var_body).to include('name')
    expect(var_body['id']).to eq('1')
    expect(var_body['name']).to eq('tstark')
  end

  it 'adds headers to message body' do
    message = UnitTestMailer.plain_message('test@example.org', '', {})
    message.mailgun_headers ||= {
      'X-Unit-Test' => 'true',
    }

    body = Railgun.transform_for_mailgun(message)

    expect(body).to include('h:X-Unit-Test')
    expect(body['h:X-Unit-Test']).to eq('true')
  end

  it 'adds headers to message body from mailer' do
    message = UnitTestMailer.plain_message('test@example.org', '', {
      'X-Unit-Test-2' => 'true',
    })

    body = Railgun.transform_for_mailgun(message)

    expect(body).to include('h:X-Unit-Test-2')
    expect(body['h:X-Unit-Test-2']).to eq('true')
  end

  it 'properly handles headers that are passed as separate POST params' do
    message = UnitTestMailer.plain_message('test@example.org', 'Test!', {
      # `From`, `To`, and `Subject` are set on the envelope, so they should be ignored as headers
      'From' => 'units@example.net',
      'To' => 'user@example.com',
      'Subject' => 'This should disappear',
      # If `Bcc` or `Cc` are set as headers, they should be carried over as POST params, not headers
      'Bcc' => ['list@example.org'],
      'Cc' => ['admin@example.com'],
      # This is an arbitrary header and should be carried over properly
      'X-Source' => 'unit tests',
    })

    body = Railgun.transform_for_mailgun(message)

    ['From', 'To', 'Subject'].each do |header|
      expect(body).not_to include("h:#{header}")
    end

    ['bcc', 'cc', 'to', 'h:X-Source'].each do |param|
      expect(body).to include(param)
    end

    expect(body[:from][0].value).to eq('unittest@example.org')
    expect(body['to']).to eq(['test@example.org'])
    expect(body[:subject]).to eq(['Test!'])
    expect(body[:text]).to eq(['Test!'])
    expect(body[:html]).to eq(['<p>Test!</p>'.html_safe])
    expect(body['bcc']).to eq(['list@example.org'])
    expect(body['cc']).to eq(['admin@example.com'])
    expect(body['h:X-Source']).to eq('unit tests')
  end

  it 'properly adds attachments' do
    message = UnitTestMailer.message_with_attachment('test@example.org', '')
    body = Railgun.transform_for_mailgun(message)

    expect(body).to include(:attachment)
    attachment = body[:attachment][0]

    expect(attachment.filename).to eq('info.txt')
    expect(attachment.content_type).to eq('text/plain')
  end

  it 'delivers!' do
    message = UnitTestMailer.plain_message('test@example.org', '', {})
    message.deliver_now

    expect(ActionMailer::Base.deliveries).to include(message)
  end

end
