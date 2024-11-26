Mailgun - Metrics
====================

This is the Mailgun Ruby *Metrics* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions. It currently supports
all calls except credentials.

---

Mailgun collects many different events and generates event metrics which are available
in your Control Panel. This data is also available via our analytics metrics API endpoint.

You can view additional samples in the [metrics_spec.rb](/spec/integration/metrics_spec.rb)
or the Metrics client API in [metrics.rb](/lib/metrics/metrics.rb).

Usage
-----

To get an instance of the Metrics client:

```ruby
require 'mailgun'

mg_client = Mailgun::Client.new('your-api-key', 'mailgun-api-host', 'v1')
metrics = Mailgun::Metrics.new(mg_client)
````
---
Get filtered metrics for an account:
```ruby
options = {
  {
    resolution: 'hour',
    metrics: [
      'accepted_count',
      'delivered_count',
      'clicked_rate',
      'opened_rate'
    ],
    include_aggregates: true,
    start: 'Tue, 26 Nov 2024 20:56:50 -0500',
    duration: '1m',
    filter: {
      AND: [
        {
          attribute: 'domain',
          comparator: '!=',
          values: [
            {
              label: 'example.com',
              value: 'example.com'
            }
          ]
        }
      ]
    },
    dimensions: ['time'],
    end: 'Tue, 30 Nov 2024 20:56:50 -0500',
    include_subaccounts: true
  }
}

metrics.account_metrics(options)
```
---

Get filtered usage metrics for an account:
```ruby
options = {
  resolution: 'hour',
  metrics: [
    'accepted_count',
    'delivered_count',
    'clicked_rate',
    'opened_rate'
  ],
  include_aggregates: true,
  start: 'Tue, 26 Nov 2024 20:56:50 -0500',
  duration: '1m',
  filter: {
    AND: [
      {
        attribute: 'domain',
        comparator: '!=',
        values: [
          {
            label: 'example.com',
            value: 'example.com'
          }
        ]
      }
    ]
  },
  dimensions: ['time'],
  end: 'Tue, 30 Nov 2024 20:56:50 -0500',
  include_subaccounts: true
}

metrics.account_usage_metrics(options)
```

---

More Documentation
------------------
See the official [Mailgun Domain Docs](https://documentation.mailgun.com/docs/mailgun/api-reference/openapi-final/tag/Metrics/)
for more information
