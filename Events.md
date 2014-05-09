Mailgun - Events
====================

This is the Mailgun Ruby *Events* utility.

The below assumes you've already installed the Mailgun Ruby SDK in your project.
If not, go back to the master README for a few quick install steps.

Events: Provides methods for traversing the Mailgun Events API.


Usage - Events
-----------------------------------------------------
Here's how to use the Events Handler to pull events.

```ruby
# First, instantiate the SDK with your API credentials, domain, and required parameters for example.
mg_client = Mailgun::Client.new("your-api-key")
mg_events = Mailgun::Events.new(mg_client, "your-domain")

result = mg_events.get({'limit' => 25,
                        'recipient' => 'joe@example.com'})

result.to_h['items'].each do | item |
    # outputs "Delivered - 20140509184016.12571.48844@example.com"
    puts "#{item['event']} - #{item['message']['headers']['message-id']}"
end

# Want more results?
result = mg_events.next

# Go backwards?
result = mg_events.previous
```

A few notes:  
1. Next will use the pagination links to advance the result set.
Retain the mg_events object to query forward, or reverse, at any time.  
2. If the result set is less than your limit, do not worry. A
second query against "next" will return the next 25 results since the
last time you called "next".

More Documentation
------------------
See the official [Mailgun Docs](http://documentation.mailgun.com/api-sending.html)
for more information.
