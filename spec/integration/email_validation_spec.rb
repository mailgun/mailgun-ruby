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
        "is_valid" => true,
        "parts" => {
            "display_name" => nil,
            "domain" => "mailgun.net",
            "local_part" => "alice",
        },
    }
    expect(res).to eq(expected)
  end

  it 'fails to validate example.org' do
    res = @mg_obj.validate("example.org")

    expected = {
        "address" => "example.org",
        "did_you_mean" => nil,
        "is_valid" => false,
        "parts" => {
            "display_name" => nil,
            "domain" => nil,
            "local_part" => nil,
        },
    }
    expect(res).to eq(expected)
  end

end
