require 'spec_helper'
require 'mailgun'
require 'pry'

vcr_opts = { :cassette_name => "templates" }

describe 'For the templates endpoint', order: :defined, vcr: vcr_opts do
  let(:client) { Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL) }
  let(:domain) { TESTDOMAIN }
  let(:templates) { Mailgun::Templates.new(client, domain) }
  let(:template_name) { 'integration_test' }
  let(:description) { 'Just testing' }
  let(:template) { '<p>Test!</p>' }
  let(:created_template) do
    {
      'name' => template_name,
      'description' => description
    }
  end
  
  it 'creates a template' do
    result = templates.create(template_name, description, template)
    expect(result['message']).to match(/template has been stored/)
    expect(result).to have_key('template')
    expect(result['template']).to have_key('version')
    expect(result['template']['version']['active']).to be_truthy
  end

  it 'gets a template' do
    result = templates.get('integration_test')
    expect(result).to have_key('template')
    expect(result['template']['name']).to eq('integration_test')
  end

  it 'gets a list of all templates' do
    result = templates.list
    expect(result).to be_a(Array)
    expect(result).to include(hash_including(created_template))
  end

  it 'updates a template' do
    result = templates.update(template_name, 'Just testing the update')
    expect(result['message']).to match(/template has been updated/)
  end

  it 'can add a new version' do
    result = templates.add_version(template_name, '<p>New verion!</p>', 'v2', active: 'yes')
    expect(result['message']).to match(/has been stored/)
    expect(result['template']['name']).to eq('integration_test')
    expect(result['template']).to have_key('version')
    expect(result['template']['version']['tag']).to eq('v2')
  end
  
  it 'removes a template' do
    result = templates.delete(template_name)
    expect(result['message']).to match(/template has been deleted/)
  end
end

