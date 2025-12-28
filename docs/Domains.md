Mailgun - Domains
====================

This is the Mailgun Ruby *Domain* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions. It currently supports
all calls except credentials.

Usage - Domains
-----------------------
First, instantiate the Mailgun Client with your API key
```ruby
mg_client = Mailgun::Client.new('your-api-key')
domainer = Mailgun::Domains.new(mg_client)
```

Core Domain methods:

```ruby
# Get a list of current domains.
domainer.list

# Add a new domain
domainer.create 'my.new.moreness'
# or with options
domainer.create 'my.new.moreness', { some: 'options' }

# View details of a domain
domainer.get 'my.perfect.domain'

# Update a domain
domainer.update 'my.new.moreness', { some: 'options' }

# Verify a domain
domainer.verify 'my.perfect.domain'

# Remove a domain
domainer.remove 'this.one.is.not.needed.'


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

Domain Tracking methods:

```ruby
# Get tracking settings
domainer.get_domain_tracking_settings 'my.perfect.domain'

# Update click tracking settings
domainer.update_domain_tracking_click_settings 'my.perfect.domain', { some: 'options' }

# Update open tracking settings
domainer.update_domain_tracking_open_settings 'my.perfect.domain', { some: 'options' }

# Update unsubscribe tracking settings
domainer.update_domain_tracking_unsubscribe_settings  'my.perfect.domain', { some: 'options' }

# Tracking Certificate: Get certificate and status
domainer.get_domain_tracking_certificate 'my.perfect.domain'

# Tracking Certificate: Regenerate expired certificate
domainer.regenerate_domain_tracking_certificate 'my.perfect.domain', { some: 'options' }

# Tracking Certificate: Generate
domainer.generate_domain_tracking_certificate 'my.perfect.domain', { some: 'options' }
```

DKIM Security methods:

```ruby
# Update Automatic Sender Security DKIM key rotation for a domain
domainer.dkim_rotation 'my.perfect.domain', true, { some: 'options' }

# Rotate Automatic Sender Security DKIM key for a domain
domainer.dkim_rotate 'my.perfect.domain'
```

More Documentation
------------------
See the official [Mailgun Domain Docs](https://documentation.mailgun.com/docs/mailgun/api-reference/send/mailgun/domains)
for more information
