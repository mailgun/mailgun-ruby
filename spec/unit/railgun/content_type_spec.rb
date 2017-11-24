require 'spec_helper'
require 'mailgun'
require 'railgun'

describe 'extract_body' do

  let(:text_mail_option) {
    {
      from:        'bob@example.com',
      to:          'sally@example.com',
      subject:     'RAILGUN TEST SAMPLE',
      body:         text_content,
      content_type: 'text/plain',
    }
  }
  let(:text_content) { '[TEST] Hello, world.' }

  let(:html_mail_option) {
    {
      from:        'bob@example.com',
      to:          'sally@example.com',
      subject:     'RAILGUN TEST SAMPLE',
      body:         html_content,
      content_type: 'text/html',
    }
  }
  let(:html_content) { '<h3> [TEST] </h3> <br/> Hello, world!' }

  context 'with <Content-Type: text/plain>' do
    let(:sample_mail) { Mail.new(text_mail_option) }

    it 'should return body text' do
      expect(Railgun.extract_body_text(sample_mail)).to eq(text_content)
    end

    it 'should not return body html' do
      expect(Railgun.extract_body_html(sample_mail)).to be_nil
    end
  end

  context 'with <Content-Type: text/html>' do
    let(:sample_mail) { Mail.new(html_mail_option) }

    it 'should not return body text' do
      expect(Railgun.extract_body_text(sample_mail)).to be_nil
    end

    it 'should return body html' do
      expect(Railgun.extract_body_html(sample_mail)).to eq(html_content)
    end
  end

  context 'with <Content-Type: multipart/alternative>' do
    let(:text_mail) { Mail.new(text_mail_option) }
    let(:html_mail) { Mail.new(html_mail_option) }

    before do
      @sample_mail = Mail::Part.new(content_type: "multipart/alternative")
      @sample_mail.add_part text_mail
      @sample_mail.add_part html_mail
    end

    it 'should return body text' do
      expect(Railgun.extract_body_text(@sample_mail)).to eq(text_content)
    end

    it 'should return body html' do
      expect(Railgun.extract_body_html(@sample_mail)).to eq(html_content)
    end
  end
end
