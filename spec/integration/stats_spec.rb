require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "stats" }

describe 'For the Stats endpoint', vcr: vcr_opts do
  before(:all) do
    @mg_obj = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @domain = TESTDOMAIN
  end

  it 'get some stats.' do
    @mg_obj.get("#{@domain}/stats", {:limit => 50, :skip => 10, :event => 'sent'})
  end
end
