# frozen_string_literal: true

require 'spec_helper'

require 'mailgun'
require 'mailgun/helpers/api_version_checker'

describe Mailgun::ApiVersionChecker do
  # Build a minimal host class that includes the module, with a controllable
  # @client so we can set api_version per example.
  subject(:instance) { host_class.new(client) }

  let(:client) { double(:client) }

  let(:host_class) do
    Class.new do
      include Mailgun::ApiVersionChecker

      attr_reader :result

      def initialize(client)
        @client = client
      end

      def do_something(arg = nil)
        @result = arg || :called
      end
    end
  end

  # ──────────────────────────────────────────────────────────────────────────
  # .included / module structure
  # ──────────────────────────────────────────────────────────────────────────

  describe '.included' do
    it 'extends the including class with ClassMethods' do
      expect(host_class).to respond_to(:requires_api_version)
      expect(host_class).to respond_to(:enforces_api_version)
    end

    it 'does not expose ClassMethods as instance methods' do
      expect(instance).not_to respond_to(:requires_api_version)
      expect(instance).not_to respond_to(:enforces_api_version)
    end
  end

  # ──────────────────────────────────────────────────────────────────────────
  # .requires_api_version  (warns but still calls through)
  # ──────────────────────────────────────────────────────────────────────────

  describe '.requires_api_version' do
    before { host_class.requires_api_version('v3', :do_something) }

    context 'when the client is on the expected version' do
      before { allow(client).to receive(:api_version).and_return('v3') }

      it 'does not emit a warning' do
        expect { instance.do_something }.not_to output.to_stderr
      end

      it 'still calls the original method' do
        instance.do_something(:payload)
        expect(instance.result).to eq(:payload)
      end

      it 'forwards all arguments to the original method' do
        instance.do_something(:forwarded_arg)
        expect(instance.result).to eq(:forwarded_arg)
      end
    end

    context 'when the client is on a different version' do
      before { allow(client).to receive(:api_version).and_return('v4') }

      it 'emits a warning to stderr' do
        expect { instance.do_something }
          .to output(/WARN: Client api version must be v3/).to_stderr
      end

      it 'still calls the original method despite the warning' do
        instance.do_something(:payload)
        expect(instance.result).to eq(:payload)
      end

      it 'warning message includes the expected version' do
        expect { instance.do_something }
          .to output(/v3/).to_stderr
      end
    end

    it 'wraps multiple methods when given a list' do
      host_class.class_eval { def do_other = @result = :other }
      host_class.requires_api_version('v3', :do_something, :do_other)

      allow(client).to receive(:api_version).and_return('v4')

      expect { instance.do_something }.to output(/v3/).to_stderr
      expect { instance.do_other }.to output(/v3/).to_stderr
    end

    it 'wraps only the listed methods, leaving others unwrapped' do
      host_class.class_eval { def unwrapped = @result = :unwrapped }
      host_class.requires_api_version('v3', :do_something)

      allow(client).to receive(:api_version).and_return('v4')

      # unwrapped should not warn
      expect { instance.unwrapped }.not_to output.to_stderr
    end
  end

  # ──────────────────────────────────────────────────────────────────────────
  # .enforces_api_version  (raises on version mismatch)
  # ──────────────────────────────────────────────────────────────────────────

  describe '.enforces_api_version' do
    before { host_class.enforces_api_version('v3', :do_something) }

    context 'when the client is on the expected version' do
      before { allow(client).to receive(:api_version).and_return('v3') }

      it 'does not raise' do
        expect { instance.do_something }.not_to raise_error
      end

      it 'calls the original method' do
        instance.do_something(:payload)
        expect(instance.result).to eq(:payload)
      end

      it 'forwards all arguments to the original method' do
        instance.do_something(:forwarded_arg)
        expect(instance.result).to eq(:forwarded_arg)
      end
    end

    context 'when the client is on a different version' do
      before { allow(client).to receive(:api_version).and_return('v4') }

      it 'raises Mailgun::ParameterError' do
        expect { instance.do_something }
          .to raise_error(Mailgun::ParameterError)
      end

      it 'raises with a message including the expected version' do
        expect { instance.do_something }
          .to raise_error(Mailgun::ParameterError, /v3/)
      end

      it 'does not call the original method' do
        begin
          instance.do_something
        rescue StandardError
          nil
        end
        expect(instance.result).to be_nil
      end
    end

    it 'wraps multiple methods when given a list' do
      host_class.class_eval { def do_other = @result = :other }
      host_class.enforces_api_version('v3', :do_something, :do_other)

      allow(client).to receive(:api_version).and_return('v4')

      expect { instance.do_something }.to raise_error(Mailgun::ParameterError)
      expect { instance.do_other }.to raise_error(Mailgun::ParameterError)
    end

    it 'wraps only the listed methods, leaving others unwrapped' do
      host_class.class_eval { def unwrapped = @result = :unwrapped }
      host_class.enforces_api_version('v3', :do_something)

      allow(client).to receive(:api_version).and_return('v4')

      expect { instance.unwrapped }.not_to raise_error
    end
  end

  # ──────────────────────────────────────────────────────────────────────────
  # requires vs enforces contrast
  # ──────────────────────────────────────────────────────────────────────────

  describe 'requires_api_version vs enforces_api_version' do
    before do
      host_class.class_eval do
        def soft_method = @result = :soft
        def hard_method = @result = :hard
      end
      host_class.requires_api_version('v3', :soft_method)
      host_class.enforces_api_version('v3', :hard_method)

      allow(client).to receive(:api_version).and_return('v4')
    end

    it 'requires_api_version warns but does not raise' do
      expect { instance.soft_method }.to output(/v3/).to_stderr
      expect(instance.result).to eq(:soft)
    end

    it 'enforces_api_version raises and does not call through' do
      expect { instance.hard_method }.to raise_error(Mailgun::ParameterError)
      expect(instance.result).not_to eq(:hard)
    end
  end
end
