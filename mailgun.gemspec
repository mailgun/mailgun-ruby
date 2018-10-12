# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailgun/version'

Gem::Specification.new do |spec|

  spec.name             = 'mailgun-ruby'
  spec.version          = Mailgun::VERSION
  spec.homepage         = 'http://www.mailgun.com'
  spec.platform         = Gem::Platform::RUBY
  spec.license          = 'Apache-2.0'

  spec.summary          = "Mailgun's Official Ruby SDK"
  spec.description      = "Mailgun's Official Ruby SDK for interacting with the Mailgun API."

  spec.authors          = ['Mailgun', 'Travis Swientek']
  spec.email            = 'support@mailgunhq.com'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.2.2'

  spec.add_development_dependency 'bundler', '~> 1.16.2'
  spec.add_development_dependency 'rspec', '~> 3.8.0'
  spec.add_development_dependency 'rake', '~> 12.3.1'
  spec.add_development_dependency 'webmock', '~> 3.4.2'
  spec.add_development_dependency 'pry', '~> 0.11.3'
  spec.add_development_dependency 'vcr', '~> 3.0.3'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
  spec.add_development_dependency 'rails'
  spec.add_dependency 'rest-client', '~> 2.0.2'

end
