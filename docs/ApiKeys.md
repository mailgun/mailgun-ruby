Mailgun - API Keys
====================

This is the Mailgun Ruby *API Keys* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions.

Usage - API Keys
-----------------------

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new('your-api-key', 'api.mailgun.net', 'v1')
api_keys = Mailgun::ApiKeys.new(mg_client)
```

API Keys methods:

```ruby
# List API keys
api_keys.list

# List API keys filtered by kind and domain
api_keys.list(kind: 'domain', domain_name: 'my.perfect.domain')

# Create a user API key
api_keys.create(
  kind: 'user',
  role: 'admin',
  description: 'desc'
)

# Create a sending key for a domain, expiring in 1 day
api_keys.create(
  kind: 'domain',
  domain_name: 'my.perfect.domain',
  role: 'sending',
  expiration: 86_400
)

# Delete an API key
api_keys.remove('key-id')

# Regenerate the public API key
api_keys.regenerate
```

Supported `create` options:

| Option        | Description |
|---------------|-------------|
| `kind`        | Type of API key: `domain`, `user` or `web`. Defaults to `user` |
| `role`        | Key role: `admin`, `basic`, `sending` (for `domain` keys) or `developer` |
| `domain_name` | Domain to associate with the key, for `domain` keys |
| `description` | Key description |
| `expiration`  | Key lifetime in seconds, must be greater than 0 if set |
| `user_id`     | API key user's ID, should be provided for `web` keys |
| `user_name`   | API key user's name |
| `email`       | API key user's email address, should be provided for `web` keys |

More Documentation
------------------
See the official [Mailgun API Keys Docs](https://documentation.mailgun.com/docs/mailgun/api-reference/send/mailgun/keys)
for more information
