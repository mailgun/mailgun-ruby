Mailgun - Webhooks
====================

This is the Mailgun Ruby *Webhook* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions. It currently supports
all calls except updating webhooks.

Usage - Webhooks
-----------------------

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new('your-api-key')
hook = Mailgun::Webhooks.new(mg_client)

# Get a list webhooks for a domain.
hook.list 'my.perfect.domain'

# View a single webhook detail
hook.info 'my.perfect.domain', 'deliver'

# Add a single url for all webhooks
hook.create_all 'my.perfect.domain', 'https://the.webhook.url/'

# Add a url for a specific webhook
hook.create 'my.perfect.domain', 'deliver', 'https://the.webhook.url/'

# Remove a url for a specific webhook
hook.remove 'my.perfect.domain', 'deliver'

# Remove all webhooks for a domain
hook.remove 'my.perfect.domain'
```

More Documentation
------------------
See the official [Mailgun Domain Docs](https://documentation.mailgun.com/api-webhooks.html)
for more information
