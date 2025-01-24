require 'spec_helper'
require 'json'
require 'logger'
require 'railgun'
require 'mailgun'
require 'mailgun/exceptions/exceptions'

ActionMailer::Base.raise_delivery_errors = true
Rails.logger = Logger.new('/dev/null')
Rails.logger.level = Logger::DEBUG

class UnitTestMailer < ActionMailer::Base
  default from: 'unittest@example.org'

  def plain_message(address, from, subject, headers)
    headers(headers)
    mail(to: address, from: from, subject: subject) do |format|
      format.text { render plain: 'Test!' }
      format.html { render html: '<p>Test!</p>'.html_safe }
    end
  end
end

vcr_opts = { :cassette_name => 'message_deliver' }

describe 'Message deliver', vcr: vcr_opts do
  let(:domain) { TESTDOMAIN }
  let(:config) do
    {
      api_key: APIKEY,
      domain: domain
    }
  end
  let(:mail) { UnitTestMailer.plain_message("bob@#{domain}", "bob@#{domain}", 'subject', {}) }

  it 'successfully delivers message' do
    result = Railgun::Mailer.new(config).deliver!(mail)
    result.to_h!

    expect(result.body['message']).to eq('Queued. Thank you.')
    expect(result.body).to include('id')
    expect(result.code).to eq(200)
  end
end

vcr_opts = { :cassette_name => 'mailer_invalid_domain' }

describe 'Invalid domain', vcr: vcr_opts do
  let(:domain) { 'not-our-doma.in' }
  let(:config) do
    {
      api_key: APIKEY,
      domain: domain
    }
  end
  let(:mail) { UnitTestMailer.plain_message('sally@not-our-doma.in', "bob@#{domain}", 'subject', {}) }

  it 'raises expected error' do
    expect { Railgun::Mailer.new(config).deliver!(mail) }.to raise_error Mailgun::CommunicationError, /Forbidden/
  end
end
