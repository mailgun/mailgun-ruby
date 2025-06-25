Mailgun - Logs
====================

This is the Mailgun Ruby *Logs* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions. It currently supports
all calls except credentials.

---

Mailgun collects many different events and generates event logs which are available
in your Control Panel. This data is also available via our analytics logs API endpoint.

You can view additional samples in the [logs_spec.rb](/spec/integration/logs_spec.rb)
or the Logs client API in [logs.rb](/lib/logs/logs.rb).

Usage
-----

To get an instance of the Logs client:

```ruby
require 'mailgun'

mg_client = Mailgun::Client.new('your-api-key', 'mailgun-api-host', 'v1')
logs = Mailgun::Logs.new(mg_client)
````
---
Get filtered logs for an account:
```ruby
options = {
  {
    start: 'Mon, 08 Jul 2024 00:00:00 -0000',
    end: 'Fri, 12 Jul 2024 00:00:00 -0000',
    filter: {
      AND: [
        {
          attribute: 'domain',
          comparator: '=',
          values: [
            {
              label: 'example.com',
              value: 'example.com'
            }
          ]
        }
      ]
    },
    include_subaccounts: true,
    pagination: {
      sort: 'timestamp:asc',
      token: 'cjsijbijewbu78t678tVTYUYU76754fyuiksin865g',
      limit: 50
    }
  }
}

logs.account_logs(options)
```

---

More Documentation
------------------
See the official [Mailgun Domain Docs](https://documentation.mailgun.com/docs/mailgun/api-reference/openapi-final/tag/Logs/)
for more information
