require 'spec_helper'

require 'mailgun'
require 'mailgun/address'

vcr_opts = { :cassette_name => "email_validation" }

describe 'For the email validation endpoint', order: :defined, vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Address.new(PUB_APIKEY)

    @valid = ["Alice <alice@example.com>", "bob@example.com"]
    @invalid = ["example.org"]

    @all_addrs = @valid + @invalid
  end

  it 'returns parsed and unparsable lists' do
    res = @mg_obj.parse(@all_addrs)

    expect(res["parsed"]).to eq(@valid)
    expect(res["unparseable"]).to eq(@invalid)
  end

  it 'validates alice@mailgun.net with info' do
    res = @mg_obj.validate("alice@mailgun.net")

    expected = {
        "address" => "alice@mailgun.net",
        "did_you_mean" => nil,
        "is_disposable_address" => false,
        "is_role_address" => false,
        "is_valid" => true,
        "mailbox_verification" => "true",
        "reason" => nil,
        "parts" => {
            "display_name" => nil,
            "domain" => "mailgun.net",
            "local_part" => "alice",
        },
    }
    expect(res).to eq(expected)
  end

  it 'performs mailbox validation for alice@mailgun.net' do
    res = @mg_obj.validate("alice@mailgun.net", true)

    expect(res["mailbox_verification"]).to eq("true")
  end

  it 'fails to validate example.org' do
    res = @mg_obj.validate("example.org")

    expected = {
        "address" => "example.org",
        "did_you_mean" => nil,
        "is_disposable_address" => false,
        "is_role_address" => false,
        "is_valid" => false,
        "mailbox_verification" => "unknown",
        "reason" => "Validation failed for 'example.org', reason: 'malformed address; missing @ sign'",
        "parts" => {
            "display_name" => nil,
            "domain" => nil,
            "local_part" => nil,
        },
    }
    expect(res).to eq(expected)
  end

end
