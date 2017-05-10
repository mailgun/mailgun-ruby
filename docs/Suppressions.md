Mailgun - Suppressions
====================

This is the Mailgun Ruby *Suppressions* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions. It currently supports
all calls except credentials.

----

The Suppressions client lets you manage bounces, unsubscribes, and complaints for a
single domain.

You can view additional samples in the [suppressions_spec.rb](/spec/integration/suppressions_spec.rb)
or the Suppressions client API in [suppressions.rb](/lib/mailgun/suppressions.rb).


Usage
-----

To get an instance of the Suppressions client:

```ruby
mg_client = Mailgun::Client.new('api_key')
supp_client = mg_client.suppressions('yourdomain.com')
```

----

To get a list of bounces, unsubscribes, and/or complaints:

```ruby
supp_client.list_bounces
supp_client.list_unsubscribes
supp_client.list_complaints
```

----

To batch-add a set of bounces:

```ruby
@addresses = <load or generate some addresses...>

bounces = []
@addresses.each do |addr|
  bounces.push({
    :address => addr,
    :code => 500,
    :error => 'some bounce because reasons',
  })
end

response, addt_responses = @supp_client.create_bounces bounces
```

`create_bounces`, `create_unsubscribes`, and `create_complaints` will all
return two values - first, a simple `Mailgun::Response` object. Second,
a list containing any `Mailgun::Response` objects created recursively, if over 998
bounces were provided to `create_*`.

----

To delete bounces:

```ruby
@addresses = <load addresses...>

@addresses.each do |addr|
  @supp_client.delete_bounce addr
end
```

Or, alternatively, to remove *all* bounces:

```ruby
@supp_client.delete_all_bounces
```

The `delete_*` methods are similar for `bounces`, `unsubscribe`, and `complaints` -
they all will return a `Mailgun::Response` object.
