Mailgun - Domains
====================

This is the Mailgun Ruby *Domain* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions. It currently supports
all calls except credentials.

Usage - Domains
-----------------------

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new('your-api-key')
domainer = Mailgun::Domains.new(mg_client)

# Get a list of current domains.
domainer.list

# View details of a domain
domainer.info 'my.perfect.domain'

# Add a new domain
domainer.create 'my.new.moreness'
# or with options
domainer.create 'my.new.moreness', { some: 'options' }

# Remove a domain
domainer.remove 'this.one.is.not.needed.'
```

Suppressions for a Domain
-------------------------

You can manage domain suppressions (bounces, unsubscribes, complaints) using the
[`Mailgun::Suppressions`](/docs/Suppressions.md) client:

```ruby
# Instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new('your-api-key')
supp_client = mg_client.suppressions('example.org')

# ...
```

See the [Suppressions](/docs/Suppressions.md) for usage samples and
[suppressions.rb](/lib/mailgun/suppressions.rb) for suppressions client API.


More Documentation
------------------
See the official [Mailgun Domain Docs](https://documentation.mailgun.com/api-domains.html)
for more information
