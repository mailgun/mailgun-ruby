require 'spec_helper'

describe 'The method get' do
  it 'should return a proper hash of log data.' do
    @mg_obj = Mailgun::UnitClient.new('events')
    events = Mailgun::Events.new(@mg_obj, "samples.mailgun.org")
    result = events.get()
    result.body.should include("items")
    result.body.should include("paging")
  end
end


describe 'The method next' do
  it 'should return the next series of data.' do
    @mg_obj = Mailgun::UnitClient.new('events')
    events = Mailgun::Events.new(@mg_obj, "samples.mailgun.org")
    result = events.next()
    result.body.should include("items")
    result.body.should include("paging")
  end
end

describe 'The method previous' do
  it 'should return the previous series of data.' do
    @mg_obj = Mailgun::UnitClient.new('events')
    events = Mailgun::Events.new(@mg_obj, "samples.mailgun.org")
    result = events.previous()
    result.body.should include("items")
    result.body.should include("paging")
  end
end
