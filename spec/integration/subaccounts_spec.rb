require 'spec_helper'
require 'mailgun'

vcr_opts = { :cassette_name => "subaccounts" }

describe 'For the subaccounts endpoints', vcr: vcr_opts do
  let(:name) { 'test.subaccount' }
  let(:subaccount_id) { 'xxx' }

  before(:all) do
    @mg_obj = Mailgun::Subaccounts.new
  end

  describe '#create' do
    it 'creates the subaccount' do
      result = @mg_obj.create(name)

      expect(result).to eq ''
    end
  end


  describe '#list' do
    it 'returns a list of templates' do
      result = @mg_obj.list

      expect(result).to eq ''
    end
  end

  describe '#info' do
    it 'gets the templates info' do
      result = @mg_obj.info(subaccount_id)

      expect(result).to eq ''
    end
  end



  describe '#enable' do
    it 'enables the subaccount' do
      result = @mg_obj.enable(subaccount_id)

      expect(result).to eq ''
    end
  end

  describe '#disable' do
    it 'disables the subaccount' do
      result = @mg_obj.disable(subaccount_id)

      expect(result).to eq ''
    end
  end

end
