Mailgun - Webhooks
====================

This is the Mailgun Ruby *Webhook* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions.

Usage - Webhooks
-----------------------

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new('your-api-key')
hook = Mailgun::Webhooks.new(mg_client)

# Get a list webhooks for a domain.
hook.list 'my.perfect.domain'

# View a single webhook detail
hook.info 'my.perfect.domain', 'delivered'

# Add a single url for all webhooks
hook.create_all 'my.perfect.domain', 'https://the.webhook.url/'

# Add a url for a specific webhook
hook.create 'my.perfect.domain', 'delivered', 'https://the.webhook.url/'

# Update the url for a specific webhook
hook.update 'my.perfect.domain', 'delivered', 'https://the.webhook.url/'

# Remove a url for a specific webhook
hook.remove 'my.perfect.domain', 'delivered'

# Remove all webhooks for a domain
hook.remove_all 'my.perfect.domain'
```

Usage - Webhooks (v4)
-----------------------

The v4 endpoints work with a URL across multiple event types in a single request.
They require a client configured for the `v4` API.

```ruby
mg_client = Mailgun::Client.new('your-api-key', 'api.mailgun.net', 'v4')
hook = Mailgun::Webhooks.new(mg_client)

# Associate a url with one or more event types
hook.create_v4 'my.perfect.domain', url: 'https://the.webhook.url/', event_types: %w[delivered opened]

# Replace the event types associated with a url
hook.update_v4 'my.perfect.domain', url: 'https://the.webhook.url/', event_types: %w[clicked]

# Remove one or more urls from all event types they are associated with
hook.remove_v4 'my.perfect.domain', url: 'https://the.webhook.url/'
hook.remove_v4 'my.perfect.domain', url: ['https://the.webhook.url/', 'https://another.webhook.url/']
```

Each v4 method returns a Hash of the domain's webhooks keyed by event type.

More Documentation
------------------
See the official [Mailgun Webhooks Docs](https://documentation.mailgun.com/docs/mailgun/api-reference/send/mailgun/domain-webhooks)
for more information
