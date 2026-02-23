# frozen_string_literal: true

require 'spec_helper'

describe 'The method get' do
  it 'should return a proper hash of log data.' do
    @mg_obj = Mailgun::UnitClient.new('events')
    events = Mailgun::Events.new(@mg_obj, 'samples.mailgun.org')
    result = events.get

    expect(result.body).to include('items')
    expect(result.body).to include('paging')
  end
end

describe 'Pagination' do
  it 'should return a proper hash of log data.' do
    @mg_obj = Mailgun::UnitClient.new('events')
    events = Mailgun::Events.new(@mg_obj, 'samples.mailgun.org')
    result = events.get

    json = JSON.parse(result.body)
    expect(json).to include('paging')
    expect(json['paging']).to include('next')
    expect(json['paging']).to include('previous')
  end

  it 'should calculate proper next-page url' do
    events = Mailgun::Events.new(@mg_obj, 'samples.mailgun.org')
    output = events.send(
      :extract_endpoint_from,
      "/v3/samples.mailgun.org/events/W3siYiI6ICIyMDE3LTA1\
LTEwVDIwOjA2OjU0LjU3NiswMDowMCIsICJlIjogIjIwMTctMDUtMDhUMj\
A6MDY6NTQuNTc3KzAwOjAwIn0sIHsiYiI6ICIyMDE3LTA1LTEwVDIwOjA2\
OjU0LjU3NiswMDowMCIsICJlIjogIjIwMTctMDUtMDhUMjA6MDY6NTQuNT\
c3KzAwOjAwIn0sIFsiZiJdLCBudWxsLCBbWyJhY2NvdW50LmlkIiwgIjU4\
MDUyMTg2NzhmYTE2MTNjNzkwYjUwZiJdLCBbImRvbWFpbi5uYW1lIiwgIn\
NhbmRib3gyOTcwMTUyYWYzZDM0NTU5YmZjN2U3MTcwM2E2Y2YyNC5tYWls\
Z3VuLm9yZyJdXSwgMTAwLCBudWxsXQ=="
    )

    expect(output).to eq "W3siYiI6ICIyMDE3LTA1LTEwVDIwOjA2O\
jU0LjU3NiswMDowMCIsICJlIjogIjIwMTctMDUtMDhUMjA6MDY6NTQuNTc3\
KzAwOjAwIn0sIHsiYiI6ICIyMDE3LTA1LTEwVDIwOjA2OjU0LjU3NiswMDo\
wMCIsICJlIjogIjIwMTctMDUtMDhUMjA6MDY6NTQuNTc3KzAwOjAwIn0sIF\
siZiJdLCBudWxsLCBbWyJhY2NvdW50LmlkIiwgIjU4MDUyMTg2NzhmYTE2M\
TNjNzkwYjUwZiJdLCBbImRvbWFpbi5uYW1lIiwgInNhbmRib3gyOTcwMTUy\
YWYzZDM0NTU5YmZjN2U3MTcwM2E2Y2YyNC5tYWlsZ3VuLm9yZyJdXSwgMTA\
wLCBudWxsXQ=="
  end
end

describe 'The method next' do
  it 'should return the next series of data.' do
    @mg_obj = Mailgun::UnitClient.new('events')
    events = Mailgun::Events.new(@mg_obj, 'samples.mailgun.org')
    result = events.next

    expect(result.body).to include('items')
    expect(result.body).to include('paging')
  end
end

describe 'The method previous' do
  it 'should return the previous series of data.' do
    @mg_obj = Mailgun::UnitClient.new('events')
    events = Mailgun::Events.new(@mg_obj, 'samples.mailgun.org')
    result = events.previous

    expect(result.body).to include('items')
    expect(result.body).to include('paging')
  end
end

describe 'The method each' do
  it 'should iterate over all event items.' do
    @mg_obj = Mailgun::UnitClient.new('events')
    events = Mailgun::Events.new(@mg_obj, 'samples.mailgun.org')
    # Events from the UnitClient are actually empty.
    count = 0
    events.each do |_e|
      count += 1
    end

    # Better than nothing..
    expect(count).to eq(0)
  end
end
