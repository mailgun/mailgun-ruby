Mailgun - Routes
====================

This is the Mailgun Ruby *Routes* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions.

Usage - Routes
-----------------------

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new('your-api-key')
routes = Mailgun::Routes.new(mg_client)
```

Routes methods:

```ruby
# Create a route that forwards matching messages to your app, then stops
routes.create({
  priority: 0,
  description: 'Support inbox',
  expression: 'match_recipient("support@mg.example.com")',
  action: ['forward("https://example.com/messages")', 'stop()']
})

# List routes
routes.list
routes.list({ limit: 50, skip: 50 })

# Get a route
routes.get('route-id')

# Update a route
routes.update('route-id', {
  priority: 1,
  action: 'forward("https://example.com/v2/messages")'
})

# Delete a route
routes.remove('route-id')

# Find the route that handles an address
routes.match('support@mg.example.com')
```

Supported `create` and `update` options:

| Option        | Description |
|---------------|-------------|
| `expression`  | The filtering rule, e.g. `match_recipient(".*@mg.example.com")`. Required for `create` |
| `action`      | Action to take when the expression matches, e.g. `forward("https://example.com/messages")` or `stop()`. Pass an Array for several actions |
| `priority`    | Smaller numbers are handled first. Defaults to `0` |
| `description` | Route description |

More Documentation
------------------
See the official [Mailgun Routes Docs](https://documentation.mailgun.com/docs/mailgun/api-reference/send/mailgun/routes)
for more information
