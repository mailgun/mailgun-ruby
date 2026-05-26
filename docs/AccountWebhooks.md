Mailgun - Account Webhooks
====================

This is the Mailgun Ruby *Account Webhook* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions.

Usage - Account Webhooks
-----------------------

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new('your-api-key')
hook = Mailgun::AccountWebhooks.new(mg_client)

```

Account Webhooks methods:

```ruby
# List account-level webhooks
hook.list
hook.list('id1, id2')

# Create an account-level webhook
hook.create(
  description: 'desc',
  event_types: 'accepted',
  url: 'https://the.webhook.url/'
)

# Delete account-level webhooks
hook.remove(all: true)
hook.remove('id1, id2')

# Get account-level webhook by ID
hook.get('id1')

# Update an account-level webhook
hook.update(
  'hook',
  description: 'desc',
  event_types: 'accepted',
  url: 'https://the.webhook.url/'
)

# Delete account-level webhook by ID
hook.remove_by_id('id1')
```

More Documentation
------------------
See the official [Mailgun Account Webhooks Docs](https://documentation.mailgun.com/docs/mailgun/api-reference/send/mailgun/account-webhooks)
for more information
