Mailgun-Ruby
============

[![Build Status](https://travis-ci.org/mailgun/mailgun-ruby.svg?branch=master)](https://travis-ci.org/mailgun/mailgun-ruby) [![Gem Version](https://badge.fury.io/rb/mailgun-ruby.svg)](http://badge.fury.io/rb/mailgun-ruby)

This is the Mailgun Ruby Library. This library contains methods for easily interacting
with the Mailgun API.
Below are examples to get you started. For additional examples, please see our
official documentation
at http://documentation.mailgun.com

Installation
------------
Via RubyGems

```ruby
gem install mailgun-ruby
```

Gemfile:

```ruby
gem 'mailgun-ruby', '~>1.0.3', require: 'mailgun'
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
mg_client = Mailgun::Client.new "your-api-key"

# Define your message parameters
message_params = {:from    => 'bob@sending_domain.com',
                  :to      => 'sally@example.com',
                  :subject => 'The Ruby SDK is awesome!',
                  :text    => 'It is really easy to send a message!'}

# Send your message through the client
mg_client.send_message "sending_domain.com", message_params
```

Or obtain the last couple log items:

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new "your-api-key"

# Define the domain you wish to query
domain = "example.com"

# Issue the get request
result = mg_client.get("#{domain}/events", {:event => 'delivered'})
```

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

message_params = {:from    => 'bob@example.com',
                  :to      => 'sally@example.com',
                  :subject => 'The Ruby SDK is awesome!',
                  :text    => 'It is really easy to send a message!'}

result = mg_client.send_message("example.com", message_params).to_h!

message_id = result['id']
message = result['message']
```

Email validation
--------
For email validation you need to build the client using your Mailgun public API key.
Here's an example of how to use the call:

```ruby
mg_client = Mailgun::Client.new("your-public-api-key")
result = mg_client.validate_email('test@test-mail-domain.com').to_h!

is_valid = result['is_valid']
alternatives = result['did_you_mean']
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

*Tip: The bin id will be the URL part after bin.mailgun.net. It will be random generated letters and numbers. For example, the bin id in this URL, http://bin.mailgun.net/aecf68de, is "aecf68de".*

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new("your-api-key", "bin.mailgun.net", "aecf68de", ssl = false)

# Define your message parameters
message_params = {:from    => 'bob@sending_domain.com',
                  :to      => 'sally@example.com',
                  :subject => 'The Ruby SDK is awesome!',
                  :text    => 'It is really easy to send a message!'}

# Send your message through the client
mg_client.send_message("sending_domain.com", message_params)
```

For usage examples on each API endpoint, head over to our official documentation
pages. Or the [Snippets](Snippets.md) file.

This SDK includes a [Message Builder](Messages.md),
[Batch Message](Messages.md), [Opt-In Handler](OptInHandler.md) and [Events](Events.md) component.

Message Builder allows you to quickly create the array of parameters, required
to send a message, by calling a methods for each parameter.
Batch Message is an extension of Message Builder, and allows you to easily send
a batch message job within a few seconds. The complexity of
batch messaging is eliminated!

Support and Feedback
--------------------

Be sure to visit the Mailgun official
[documentation website](http://documentation.mailgun.com/) for additional
information about our API.

If you find a bug, please submit the issue in Github directly.
[Mailgun-Ruby Issues](https://github.com/mailgun/mailgun-ruby/issues)

As always, if you need additional assistance, drop us a note through your Control Panel at
[https://mailgun.com/cp/support](https://mailgun.com/cp/support).
