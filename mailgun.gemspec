# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailgun/version'

Gem::Specification.new do |spec|
  spec.name             = 'mailgun-ruby'
  spec.version          = Mailgun::VERSION
  spec.homepage         = 'https://www.mailgun.com/'
  spec.platform         = Gem::Platform::RUBY
  spec.license          = 'Apache-2.0'

  spec.summary          = "Mailgun's Official Ruby SDK"
  spec.description      = "Mailgun's Official Ruby SDK for interacting with the Mailgun API."

  spec.authors          = ['Mailgun', 'Travis Swientek']
  spec.email            = 'support@mailgunhq.com'

  spec.metadata['documentation_uri'] = 'https://documentation.mailgun.com/'
  spec.metadata['source_code_uri'] = 'https://github.com/mailgun/mailgun-ruby'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.0.0'

  spec.add_dependency 'faraday', '~> 2.1'
  spec.add_dependency 'faraday-multipart', '< 2'
  spec.add_dependency 'mini_mime'
  spec.add_dependency 'zeitwerk'
end
