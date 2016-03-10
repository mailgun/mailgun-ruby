require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "email_validation" }

describe 'For the Email Validation endpoint', vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Client.new(PUB_APIKEY)
  end

  it 'validates an address.' do
    result = @mg_obj.get("address/validate",
                         {:address => "test@#{TESTDOMAIN}"})

    result.to_h!
    expect(result.body["is_valid"]).to eq(true)
    expect(result.body["address"]).to eq("test@#{TESTDOMAIN}")
  end

  it 'parses an address.' do
    result = @mg_obj.get("address/parse",
                         {:addresses => "Alice <alice@#{TESTDOMAIN}>,bob@#{TESTDOMAIN},#{TESTDOMAIN}"})

    result.to_h!
    expect(result.body["parsed"]).to include("Alice <alice@#{TESTDOMAIN}>")
    expect(result.body["parsed"]).to include("bob@#{TESTDOMAIN}")
    expect(result.body["unparseable"]).to include("#{TESTDOMAIN}")
  end
end
