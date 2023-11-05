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

  def message_with_template(address, subject, template_name)
    mail(to: address, subject: subject, template: template_name) do |format|
      format.text { render plain: "Test!" }
    end
  end

  def message_with_domain(address, subject, domain)
    mail(to: address, subject: subject, domain: domain) do |format|
      format.text { render plain: "Test!" }
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

  context 'when config does not have api_key or domain' do
    it 'raises configuration error' do
      config = {
        api_key:  {}
      }

    expect { Railgun::Mailer.new(config) }.to raise_error(Railgun::ConfigurationError)
    end
  end

  context 'when fake_message_send is present in config' do
    it 'enables test mode' do
      config = {
        api_key:  {},
        domain:   {},
        fake_message_send: true
      }
      client_double = double(Mailgun::Client)
      allow(Mailgun::Client).to receive(:new).and_return(client_double)
      expect(client_double).to receive(:enable_test_mode!)

      Railgun::Mailer.new(config)
    end
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

  it 'accepts frozen options to message body' do
    message = UnitTestMailer.plain_message('test@example.org', '', {})
    message.mailgun_options ||= {
      'tags' => ['some-tag']
    }

    body = Railgun.transform_for_mailgun(message)

    expect(body).to include('o:tags')
    expect(body['o:tags']).to eq(['some-tag'])
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
      'x-unit-test' => 'true',
    }

    body = Railgun.transform_for_mailgun(message)

    expect(body).to include('h:x-unit-test')
    expect(body['h:x-unit-test']).to eq('true')
  end

  it 'adds headers to message body from mailer' do
    message = UnitTestMailer.plain_message('test@example.org', '', {
      'x-unit-test-2' => 'true',
    })

    body = Railgun.transform_for_mailgun(message)

    expect(body).to include('h:x-unit-test-2')
    expect(body['h:x-unit-test-2']).to eq('true')
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

    ['bcc', 'cc', 'to', 'h:x-source'].each do |param|
      expect(body).to include(param)
    end

    expect(body[:from][0].value).to eq('unittest@example.org')
    expect(body['to']).to eq(['test@example.org'])
    expect(body[:subject]).to eq(['Test!'])
    expect(body[:text]).to eq(['Test!'])
    expect(body[:html]).to eq(['<p>Test!</p>'.html_safe])
    expect(body['bcc']).to eq(['list@example.org'])
    expect(body['cc']).to eq(['admin@example.com'])
    expect(body['h:x-source']).to eq('unit tests')
  end

  context 'when mailgun_variables are present' do
    it 'accepts valid JSON and stores it as message[param].' do
      message = UnitTestMailer.plain_message('test@example.org', '', {}).tap do |message|
        message.mailgun_variables = {
          'my-data' => '{"key":"value"}'
        }
      end
      body = Railgun.transform_for_mailgun(message)
      expect(body["v:my-data"]).to be_kind_of(String)
      expect(body["v:my-data"].to_s).to eq('{"key":"value"}')
    end

    it 'accepts a hash and appends as data to the message.' do
      message = UnitTestMailer.plain_message('test@example.org', '', {}).tap do |message|
        message.mailgun_variables = {
          'my-data' => {'key' => 'value'}
        }
      end
      body = Railgun.transform_for_mailgun(message)

      expect(body["v:my-data"]).to be_kind_of(String)
      expect(body["v:my-data"].to_s).to eq('{"key":"value"}')
    end

    it 'accepts string values' do
      message = UnitTestMailer.plain_message('test@example.org', '', {}).tap do |message|
        message.mailgun_variables = {
          'my-data' => 'String Value.'
        }
      end
      body = Railgun.transform_for_mailgun(message)

      expect(body["v:my-data"]).to be_kind_of(String)
      expect(body["v:my-data"].to_s).to eq('String Value.')
    end
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

  it 'ignores `reply-to` in headers' do
    message = UnitTestMailer.plain_message('test@example.org', '', {
      'reply-to' => 'user@example.com',
    })
    message.mailgun_headers = {
      'Reply-To' => 'administrator@example.org',
    }
    message.headers({'REPLY-TO' => 'admin@example.net'})
    message.reply_to = "dude@example.com.au"

    body = Railgun.transform_for_mailgun(message)
    expect(body).to include('h:reply-to')
    expect(body).not_to include('h:Reply-To')
    expect(body['h:reply-to']).to eq('dude@example.com.au')
  end

  it 'ignores `mime-version` in headers' do
    message = UnitTestMailer.plain_message('test@example.org', '', {
      'mime-version' => '1.0',
    })
    message.mailgun_headers = {
      'Mime-Version' => '1.1',
    }
    message.headers({'MIME-VERSION' => '1.2'})

    body = Railgun.transform_for_mailgun(message)
    expect(body).not_to include('h:mime-version')
  end

  it 'treats `headers()` names as case-insensitve' do
    message = UnitTestMailer.plain_message('test@example.org', '', {
      'X-BIG-VALUE' => 1,
    })

    body = Railgun.transform_for_mailgun(message)
    expect(body).to include('h:x-big-value')
    expect(body['h:x-big-value']).to eq("1")
  end

  it 'treats `mailgun_headers` names as case-insensitive' do
    message = UnitTestMailer.plain_message('test@example.org', '', {})
    message.mailgun_headers = {
      'X-BIG-VALUE' => 1,
    }

    body = Railgun.transform_for_mailgun(message)
    expect(body).to include('h:x-big-value')
    expect(body['h:x-big-value']).to eq("1")
  end

  it 'handles multi-value, mixed case headers correctly' do
    message = UnitTestMailer.plain_message('test@example.org', '', {})
    message.headers({
      'x-neat-header' => 'foo',
      'X-Neat-Header' => 'bar',
      'X-NEAT-HEADER' => 'zoop',
    })

    body = Railgun.transform_for_mailgun(message)
    expect(body).to include('h:x-neat-header')
    expect(body['h:x-neat-header']).to include('foo')
    expect(body['h:x-neat-header']).to include('bar')
    expect(body['h:x-neat-header']).to include('zoop')
  end

  context 'when message with template' do
    it 'adds template header to message from mailer params' do
      template_name = 'template.name'
      message = UnitTestMailer.message_with_template('test@example.org', '', template_name)

      body = Railgun.transform_for_mailgun(message)

      expect(body).to include('template')
      expect(body['template']).to eq(template_name)
    end

    context 'when mailgun_template_variables are assigned' do
      it 'adds template variables to message body' do
        message = UnitTestMailer.message_with_template('test@example.org', '', 'template.name')
        version = 'version_1'
        message.mailgun_template_variables ||= {
          'version' => version,
          'text' => 'yes'
        }

        body = Railgun.transform_for_mailgun(message)

        expect(body).to include('t:version')
        expect(body['t:version']).to eq('version_1')
        expect(body).to include('t:text')
        expect(body['t:text']).to eq('yes')
      end
    end
  end

  describe 'deliver!' do
    let(:config) do
      {
        api_key: 'api_key',
        domain: 'domain'
      }
    end
    let(:mail) { UnitTestMailer.plain_message('test@example.org', '', {}) }
    let(:response) do
      response = Struct.new(:code, :id)
      response.new(200, rand(50..100))
    end

    it 'initiates client message send' do
      result = { from: 'test@example.org' }
      allow(Railgun).to receive(:transform_for_mailgun).and_return(result)

      expect_any_instance_of(Mailgun::Client).to receive(:send_message)
        .with(config[:domain], result)
        .and_return(response)
      Railgun::Mailer.new(config).deliver!(mail)
    end

    it 'returns response' do
      expect_any_instance_of(Mailgun::Client).to receive(:send_message).and_return(response)
      expect(Railgun::Mailer.new(config).deliver!(mail)).to eq(response)
    end

    context 'when domain is provided in arguments' do
      let(:new_domain) { 'new_domain' }
      let(:mail) { UnitTestMailer.message_with_domain('test@example.org', '', new_domain) }

      it 'uses provided domain' do
        result = { from: 'test@example.org' }
        allow(Railgun).to receive(:transform_for_mailgun).and_return(result)
        expect_any_instance_of(Mailgun::Client).to receive(:send_message)
          .with(new_domain, result).and_return(response)
        Railgun::Mailer.new(config).deliver!(mail)
      end
    end
  end
end
