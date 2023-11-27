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
  => {"subaccounts"=>[{"id"=>"XYZ", "name"=>"test.subaccount1", "status"=>"open"}, {"id"=>"YYY", "name"=>"test.subaccount2", "status"=>"open"}], "total"=>2}

  # Get subaccount information
  mb_obj.info(subaccount_id)
  => {"subaccount"=>{"id"=>"XYZ", "name"=>"test.subaccount1", "status"=>"open"}

  # Add Subaccount
  mb_obj.create(name)
  => {"subaccount"=>{"id"=>"XYZ", "name"=>"test.subaccount1", "status"=>"open"}}

  # Disable
  mb_obj.disable(subaccount_id)
  => {"subaccount"=>{"id"=>"XYZ", "name"=>"test.subaccount1", "status"=>"disabled"}}

  # Enable
  mb_obj.enable(subaccount_id)
  => {"subaccount"=>{"id"=>"XYZ", "name"=>"test.subaccount1", "status"=>"open"}}
```

Primary accounts can make API calls on behalf of their subaccounts.
```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new 'your-api-key'
mg_client.set_subaccount('SUBACCOUNT_ID')

# Define your message parameters
message_params = {  from: 'bob@SUBACCOUNT_DOMAIN',
                    to: 'sally@example.com',
                    subject: 'The Ruby SDK is awesome!',
                    text: 'It is really easy to send a message!'
                  }

# Send your message through the client
# Note: This will not actually hit the API, and will return a generic OK response.
mg_client.send_message('SUBACCOUNT_DOMAIN', message_params)

# Reset subaccount for primary usage
mg_client.reset_subaccount
```


More Documentation
------------------
See the official [Mailgun Docs](https://documentation.mailgun.com/en/latest/subaccounts.html#subaccounts)
for more information.
