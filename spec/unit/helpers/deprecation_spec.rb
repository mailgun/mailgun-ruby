# frozen_string_literal: true

require 'spec_helper'

describe Mailgun::Deprecation do
  describe '.warn' do
    it 'names the deprecated method and its replacement' do
      expect { described_class.warn('Mailgun::Old#call', 'Mailgun::New#call') }
        .to output(/DEPRECATION: "Mailgun::Old#call" is deprecated\. Please use "Mailgun::New#call" instead\.\n\z/)
        .to_stderr
    end

    it 'adds the reason and the removal version when given' do
      expect do
        described_class.warn('Mailgun::Old#call', 'Mailgun::New#call',
                             reason: 'Mailgun deprecated the Old API', removal: 'mailgun-ruby 2.0')
      end.to output(
        /is deprecated \(Mailgun deprecated the Old API\) and will be removed in mailgun-ruby 2\.0\. Please use /
      ).to_stderr
    end

    it 'prefixes the location of the caller' do
      line = __LINE__ + 1
      expect { described_class.warn('Mailgun::Old#call', 'Mailgun::New#call') }
        .to output(/\A\S*deprecation_spec\.rb:#{line}: warning: DEPRECATION: /).to_stderr
    end

    it 'skips the frames inside the gem' do
      line = __LINE__ + 1
      expect { Mailgun::MessageBuilder.new.set_subject('subject') }
        .to output(/\A\S*deprecation_spec\.rb:#{line}: warning: DEPRECATION: /).to_stderr
    end

    it 'skips the API version check wrappers' do
      client = instance_double(Mailgun::Client, api_version: 'v3', get: instance_double(Mailgun::Response, to_h: {}))
      line = __LINE__ + 1
      expect { Mailgun::Domains.new(client).get_domain_stats('example.com') }
        .to output(/\A\S*deprecation_spec\.rb:#{line}: warning: DEPRECATION: /).to_stderr
    end
  end
end
