Mailgun - Analytics Tags
====================

This is the Mailgun Ruby *Analytics Tags* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions. It currently supports
all calls except credentials.

---

Mailgun allows you to tag your email with unique identifiers. Tags are visible via our analytics tags API endpoint.

You can view additional samples in the [analytics_tags_spec.rb](/spec/integration/analytics_tags_spec.rb)
or the Analytics Tags client API in [analytics_tags.rb](/lib/mailgun/tags/analytics_tags.rb).

Usage
-----

To get an instance of the Analytics Tags client:

```ruby
require 'mailgun'

mg_client = Mailgun::Client.new('your-api-key', 'mailgun-api-host', 'v1')
tags = Mailgun::AnalyticsTags.new(mg_client)
````
---
Update account tag:
```ruby
tags.update('name-of-tag-to-update', 'updated tag description')
```
---

Post query to list account tags or search for single tag:
```ruby
options = {
  pagination: {
    sort: 'lastseen:desc',
    limit: 10
  },
  include_subaccounts: true
}

tags.list(options)
```

Delete account tag:
```ruby
tags.remove('name-of-tag-to-remove')
```

Get account tag limit information:
```ruby
tags.limits
```

---

More Documentation
------------------
See the official [Mailgun Tags New Docs](https://documentation.mailgun.com/docs/mailgun/api-reference/send/mailgun/tags-new)
for more information
