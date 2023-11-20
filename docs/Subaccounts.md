Mailgun - [Subaccounts](https://help.mailgun.com/hc/en-us/articles/16380043681435-Subaccounts)
====================

Rails
-----

The library can be initialized with a Rails initializer containing similar:
```ruby
Mailgun.configure do |config|
  config.api_key = 'your-secret-api-key'
end
```
Or have the initializer read your environment setting if you prefer.

```ruby
  Mailgun.api_key = 'your-secret-api-key'
```

```ruby
  mb_obj = Mailgun::Subaccounts.new

  # Get subaccounts list
  mb_obj.get_subaccounts(limit: 10, skip: 0, sort: 'ask', enabled: true)

  # Get subaccount information
  mb_obj.info(subaccount_id)

  # Add Subaccount
  mb_obj.create(name)

  # Disable
  mb_obj.disable(subaccount_id)

  # Enable
  mb_obj.enable(subaccount_id)
```


More Documentation
------------------
See the official [Mailgun Docs](https://documentation.mailgun.com/en/latest/subaccounts.html#subaccounts)
for more information.
