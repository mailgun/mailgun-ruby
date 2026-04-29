Mailgun - DomainKeys
====================

This is the Mailgun Ruby *DomainKeys* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions. It currently supports
all calls except credentials.

Usage - DomainKeys
-----------------------
First, instantiate the Mailgun Client with your API key
```ruby
mg_client = Mailgun::Client.new('your-api-key')
domainer = Mailgun::DomainKeys.new(mg_client)
```

Domain Keys methods:

```ruby
# List keys for all domains
domainer.list_domain_keys { some: 'options' }

# Create a domain key
domainer.create_domain_key { some: 'options' }

# Delete a domain key
domainer.delete_domain_key { some: 'options' }

# Activate a domain key
domainer.activate_domain_key 'my.perfect.domain', 'selector'

# List domain keys
domainer.get_domain_keys 'my.perfect.domain'

# Deactivate a domain key
domainer.deactivate_domain_key 'my.perfect.domain', 'selector'

# Update DKIM authority
domainer.update_domain_dkim_authority 'my.perfect.domain', { some: 'options' }

# Update a DKIM selector
domainer.update_domain_dkim_selector 'my.perfect.domain', { some: 'options' }
```

More Documentation
------------------
See the official [Mailgun Domain Docs](https://documentation.mailgun.com/docs/mailgun/api-reference/send/mailgun/domain-keys)
for more information
