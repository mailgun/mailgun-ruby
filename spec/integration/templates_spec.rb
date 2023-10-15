require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "templates" }

describe 'For the templates endpoints', vcr: vcr_opts do
  let(:template_name) { 'test.template' }
  let(:domain) { "integration-test.domain.invalid" }
  let(:tag) { 'v2' }

  before(:all) do
    @mg_client = Mailgun::Client.new(APIKEY, APIHOST, APIVERSION, SSL)
    @mg_obj = Mailgun::Templates.new(@mg_client)
  end

  describe '#create' do
    it 'creates the template' do
      result = @mg_obj.create(
        domain,
        {
          name: template_name,
          description: 'Test',
          template: '{{fname}} {{lname}}',
            comment: 'test comment',
            headers: '{"Subject": "{{subject}}"}',
            tag: 'V1'
        }
      )

      expect(result['template']["name"]).to eq('test.template')
      expect(result['template']["description"]).to eq("Test")
    end
  end

  describe '#info' do
    it 'gets the templates info' do
      result = @mg_obj.info(domain, 'test.template')

      expect(result).to include("template")
      expect(result["template"]["name"]).to eq(template_name)
    end
  end

  describe '#update' do
    it 'updates the template' do
      result = @mg_obj.update(domain, template_name, { description: 'Updated Description' })

      expect(result['message']).to eq('template has been updated')
    end
  end

  describe '#list' do
    it 'returns a list of templates' do
      result = @mg_obj.list(domain)

      expect(result.first).to have_key('name')
      expect(result.first).to have_key('description')
    end
  end

  describe '#delete' do
    it 'deletes a template' do
      result = @mg_obj.delete(domain, template_name)

      expect(result).to be_truthy
    end
  end

  describe '#remove_all' do
    it 'deletes all templates from domain' do
      result = @mg_obj.remove_all(domain)

      expect(result).to be_truthy
    end
  end

  describe '#create_version' do
    it 'creates the version for the template' do
      result = @mg_obj.create_version(
        domain,
        template_name,
        {
          template: '{{fname}} {{lname}}',
          comment: 'test comment',
          headers: '{"Subject": "{{subject}}"}',
          tag: tag,
          active: 'yes'
        }
      )

      expect(result['template']["version"]['tag']).to eq(tag)
    end
  end

  describe '#info_version' do
    it "gets the template's version info" do
      result = @mg_obj.info_version(domain, template_name, tag)

      expect(result["template"]["version"]['tag']).to eq(tag)
    end
  end

  describe '#update_version' do
    it 'updates the template' do
      result = @mg_obj.update_version(
        domain,
        template_name,
        tag,
        {
          template: '{{fname}} {{lname}}',
          comment: 'test comment 2',
          headers: '{"Subject": "{{subject}}"}'
        }
      )

      expect(result['message']).to eq('version has been updated')
    end
  end

  describe '#template_versions_list' do
    it "returns template's versions" do
      result = @mg_obj.template_versions_list(domain, template_name)

      expect(result["template"]["versions"].first).to include('tag')
    end
  end

  describe '#delete_version' do
    it "deletes template's version" do
      result = @mg_obj.delete_version(domain, template_name, tag)

      expect(result).to be_truthy
    end
  end
end
