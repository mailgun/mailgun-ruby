Mailgun-Ruby
============

[![Build Status](https://travis-ci.org/mailgun/mailgun-ruby.svg?branch=master)](https://travis-ci.org/mailgun/mailgun-ruby) [![Gem Version](https://badge.fury.io/rb/mailgun-ruby.svg)](http://badge.fury.io/rb/mailgun-ruby)

This is the Mailgun Ruby Library. This library contains methods for easily interacting
with the Mailgun API.
Below are examples to get you started. For additional examples, please see our
official documentation at https://documentation.mailgun.com

Installation
------------
Via RubyGems

```ruby
gem install mailgun-ruby
```

Gemfile:

```ruby
gem 'mailgun-ruby', '~>1.0.5', require: 'mailgun'
```

Include
--------

```ruby
require 'mailgun'
```

Usage
-----
Here's how to send a message using the library:

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new 'your-api-key'

# Define your message parameters
message_params =  { from: 'bob@sending_domain.com',
                    to:   'sally@example.com',
                    subject: 'The Ruby SDK is awesome!',
                    text:    'It is really easy to send a message!'
                  }

# Send your message through the client
mg_client.send_message 'sending_domain.com', message_params
```

Or obtain the last couple log items:

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new 'your-api-key'

# Define the domain you wish to query
domain = 'example.com'

# Issue the get request
result = mg_client.get("#{domain}/events", {:event => 'delivered'})
```

Rails
-----

The library can be initialized with a Rails initializer containing similar:
```ruby
Mailgun.configure do |config|
  config.api_key = 'your-secret-key'
end
```
Or have the initializer read your environment setting if you perfer.


Response
--------

The results are returned in a Response class:

```ruby
result = mg_client.get("#{domain}/events", {:event => 'delivered'})

# To Ruby standard Hash.
result.to_h

# To YAML.
result.to_yaml

# Or raw JSON
result.body
```

Here's an example, breaking out the response:

```ruby
mg_client = Mailgun::Client.new("your-api-key")

message_params =  {
                   from: 'bob@example.com',
                   to:   'sally@example.com',
                   subject: 'The Ruby SDK is awesome!',
                   text:    'It is really easy to send a message!'
                  }

result = mg_client.send_message('example.com', message_params).to_h!

message_id = result['id']
message = result['message']
```

Debugging
---------

Debugging the Ruby Library can be really helpful when things aren't working quite right.
To debug the library, here are some suggestions:

Set the endpoint to Mailgun's Postbin. A Postbin is a web service that allows you to
post data, which is then displayed through a browser. This allows you to quickly determine
what is actually being transmitted to Mailgun's API.

**Step 1 - Create a new Postbin.**
Go to http://bin.mailgun.net. The Postbin will generate a special URL. Save that URL.

**Step 2 - Instantiate the Mailgun client using Postbin.**

*Tip: The bin id will be the URL part after bin.mailgun.net. It will be random generated letters and numbers.
For example, the bin id in this URL, http://bin.mailgun.net/aecf68de, is "aecf68de".*

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new("your-api-key", "bin.mailgun.net", "aecf68de", ssl = false)

# Define your message parameters
message_params = {  from: 'bob@sending_domain.com',
                    to: 'sally@example.com',
                    subject: 'The Ruby SDK is awesome!',
                    text: 'It is really easy to send a message!'
                  }

# Send your message through the client
mg_client.send_message("sending_domain.com", message_params)
```

For usage examples on each API endpoint, head over to our official documentation
pages. Or the [Snippets](Snippets.md) file.

This SDK includes the following components:
- [Message Builder](Messages.md)
- [Batch Message](Messages.md)
- [Opt-In Handler](OptInHandler.md)
- [Domains](Domains.md)
- [Webhooks](Webhooks.md)
- [Events](Events.md)

Message Builder allows you to quickly create the array of parameters, required
to send a message, by calling a methods for each parameter.
Batch Message is an extension of Message Builder, and allows you to easily send
a batch message job within a few seconds. The complexity of
batch messaging is eliminated!

Testing
-------

There are unit tests and integration tests. Unit tests do not require Mailgun account keys. Integration tests do.
By default:
```
bundle exec rake spec
```
will run just unit tests. To run integration tests:
```
bundle exec rake spec:integration
```
will run just integration tests.
```
bundle exec rake spec:all
```
will run all both types.

Integrations tests will run against [VCR](https://github.com/vcr/vcr) cassettes if they exist.
If you'd like to run tests against your mailgun account, remove the cassettes.

To set up Mailgun key information. See the example file: .ruby-env.yml.example.
Rename this file to .ruby-env.yml and replace the items between the <> (including the <>) with the private
and public keys, and sandbox domain. Alternatively use a different domain registered in Mailgun if you
have one you want to test against.

The MAILGUN_* variables in .ruby-env.yml(.example) can also be set as
environment variables, if you'd like to do that instead.

Support and Feedback
--------------------

Be sure to visit the Mailgun official
[documentation website](https://documentation.mailgun.com/) for additional
information about our API.

If you find a bug, please submit the issue in Github directly.
[Mailgun-Ruby Issues](https://github.com/mailgun/mailgun-ruby/issues)

As always, if you need additional assistance, drop us a note through your Control Panel at
[https://mailgun.com/cp/support](https://mailgun.com/cp/support).
