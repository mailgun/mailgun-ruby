Mailgun - Mailing Lists
====================

This is the Mailgun Ruby *Mailing Lists* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions.

Usage - Mailing Lists
-----------------------

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new('your-api-key')
mailing_lists = Mailgun::MailingLists.new(mg_client)
```

Mailing list methods:

```ruby
# Create a list
mailing_lists.create('developers@mg.example.com', {
  name: 'Developers',
  description: 'Developers mailing list',
  access_level: 'members'
})

# Get a list
mailing_lists.get('developers@mg.example.com')

# List mailing lists
mailing_lists.list
mailing_lists.list({ limit: 50, skip: 50 })

# List mailing lists by page
page = mailing_lists.list_pages({ limit: 50 })
page['items']  # the lists on this page
page['paging'] # URLs of the first, last, next and previous pages

# Update a list
mailing_lists.update('developers@mg.example.com', {
  name: 'Developers (all)',
  access_level: 'readonly'
})

# Delete a list and all of its members
mailing_lists.remove('developers@mg.example.com')
```

Supported `create` and `update` options:

| Option             | Description |
|--------------------|-------------|
| `name`             | List name |
| `description`      | List description |
| `access_level`     | Who can post to the list: `readonly`, `members` or `everyone`. Defaults to `readonly` |
| `reply_preference` | Where replies go: `list` or `sender`. Defaults to `list` |
| `address`          | `update` only: the list's new address |

Mailing list member methods:

```ruby
# Add a member
mailing_lists.create_member('developers@mg.example.com', 'jane@example.com', {
  name: 'Jane Doe',
  vars: { age: 26 },
  subscribed: true,
  upsert: true
})

# Get a member
mailing_lists.get_member('developers@mg.example.com', 'jane@example.com')

# List members
mailing_lists.list_members('developers@mg.example.com')
mailing_lists.list_members('developers@mg.example.com', { subscribed: true, limit: 50 })

# List members by page
mailing_lists.list_members_pages('developers@mg.example.com', { limit: 50 })

# Update a member
mailing_lists.update_member('developers@mg.example.com', 'jane@example.com', {
  name: 'Jane Smith',
  subscribed: false
})

# Remove a member
mailing_lists.remove_member('developers@mg.example.com', 'jane@example.com')
```

Supported `create_member` and `update_member` options:

| Option       | Description |
|--------------|-------------|
| `name`       | Member name |
| `vars`       | Custom member variables, as a Hash or a JSON string |
| `subscribed` | Whether the member is subscribed. Defaults to `true` |
| `upsert`     | `create_member` only: update the member if it already exists instead of failing. Defaults to `false` |
| `address`    | `update_member` only: the member's new address |

Bulk member methods:

```ruby
# Add up to 1,000 members in one call, as addresses or member hashes
mailing_lists.create_members('developers@mg.example.com', [
  'bob@example.com',
  { address: 'jane@example.com', name: 'Jane Doe', vars: { age: 26 } }
], { upsert: true })

# Import up to 1,000 members from a CSV file, by path or as an IO
mailing_lists.import_members('developers@mg.example.com', 'members.csv', { upsert: true })
mailing_lists.import_members('developers@mg.example.com', File.open('members.csv'))
```

CSV imports, and JSON uploads of more than 100 members, are processed in the
background: the response confirms the upload has started, not the final member count.

More Documentation
------------------
See the official [Mailgun Mailing Lists Docs](https://documentation.mailgun.com/docs/mailgun/api-reference/send/mailgun/mailing-lists)
for more information
