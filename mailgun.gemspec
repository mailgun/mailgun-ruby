# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailgun/version'

Gem::Specification.new do |spec|

  spec.name             = "mailgun"
  spec.version          = Mailgun::VERSION
  spec.homepage         = "http://www.mailgun.com"
  spec.platform         = Gem::Platform::RUBY
  spec.license          = 'Apache'

  spec.summary          = "Mailgun's Official Ruby SDK"
  spec.description      = "This Gem allows you to interact with Mailgun's API. A few utilities are included!"

  spec.authors          = ["Mailgun", "Travis Swientek"]
  spec.email            = "support@mailgunhq.com"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.post_install_message = %q{
    ---------------------------------------------------------------
    Congrats, you've successfully installed the Mailgun SDK!
    Check out our documentation at http://documentation.mailgun.com

    Contact us at support@mailgunhq.com with any questions.
    ----------------------------------------------------------------
  }

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "rake", "~> 10.1"

  spec.add_dependency "rest-client", "~> 1.6"
  spec.add_dependency "json", "~> 1.8"

end
