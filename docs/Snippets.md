Mailgun-Ruby Snippets
=====================

This page is filled with snippets that cover almost every API endpoint and action. Copy, Paste, Go! There will be little inline documentation in these samples, please consult Mailgun's official documentation for detailed information.

If you haven't already installed the SDK, go to the README and follow the installation instructions.

These snippets require that you pipe in a few parameters. "mg_client" is instantiated like so:

```ruby
require 'mailgun'
mg_client = Mailgun::Client.new "your-api-key"
```

### Messages:
____________________________________________________
**Send a basic message: **

```ruby
data = {:from => 'bob@sending_domain.com',
                  :to => 'sally@example.com',
                  :subject => 'The Ruby SDK is awesome!',
                  :text => 'It is really easy to send a message!'}

mg_client.send_message "sending_domain.com", data
```

**Send a multipart text/html message:**

```ruby
data = {:from => 'bob@sending_domain.com',
                  :to => 'sally@example.com',
                  :subject => 'The Ruby SDK is awesome!',
                  :text => 'This is the text part.',
                  :html => '<html><body><p>This is the HTML part.</p></body></html>'}

mg_client.send_message "sending_domain.com", data
```

**Send a custom MIME message:**

```ruby
# Don't include a file, pull the file to a string
mime_string = 'From: Bob Sample <example@example.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
boundary="--boundary-goes-here--"

Your Multipart MIME body

--boundary-goes-here--
Content-Type: text/plain

This is the text part of your message.

--boundary-goes-here--'

# The envelope recipient is defined here, as well as your MIME string
data = {:to => 'sally@example.com', :message => mime_string}

mg_client.send_message "sending_domain.com", data

```

**Build a message, part by part, with Message Builder:**

```ruby
mb_obj = Mailgun::MessageBuilder.new

mb_obj.set_from_address "sender@example.com", {'first' => 'Sending', 'last' => 'User'}
mb_obj.add_recipient :to, "recipient@example.com", {'first' => 'Recipient', 'last' => 'User'}
mb_obj.set_subject "This is the subject!"
mb_obj.set_text_body "This is the text body."

mg_client.send_message "sending_domain.com", mb_obj
```

**Build a message with attachments, part by part, with Message Builder:**

```ruby
mb_obj = Mailgun::MessageBuilder.new

mb_obj.set_from_address "sender@example.com", {'first' => 'Sending', 'last' => 'User'}
mb_obj.add_recipient :to, "recipient@example.com", {'first' => 'Recipient', 'last' => 'User'}
mb_obj.set_subject "This is the subject!"
mb_obj.set_text_body "This is the text body."

# Add separate attachments
mb_obj.add_attachment "/path/to/file/invoice_8675309.pdf", "Order Invoice - 8675309.pdf"
mb_obj.add_attachment "/path/to/file/datasheet_00001.pdf", "Product Datasheet - 00001.pdf"

# Attach inline image to message
mb_obj.add_inline_image "/path/to/file/product_image_00001.png"

mg_client.send_message "sending_domain.com", mb_obj
```

**Send batches of 1000 messages per post:**

```ruby
bm_obj = Mailgun::BatchMessage.new

# Build message using Message Builder
bm_obj.set_from_address "sender@example.com", {'first' => 'Sending', 'last' => 'User'}
bm_obj.set_message_id("<20141014000000.11111.11111@example.com>") # optional
bm_obj.set_subject "This is the subject!"
bm_obj.set_text_body "This is the text body."

# Loop and add unlimited recipients (batch jobs will fire when thresholds reached)
bm_obj.add_recipient :to, "a_user@example.com"

# All message IDs returned in finalize method return
message_ids = @bm_obj.finalize
```

### Domains:
____________________________________________________
**Get a list of all domains:**

```ruby
result = @mg_client.get "domains", {:limit => 5, :skip => 0}
```

**Get a single domain:**

```ruby
result = @mg_client.get "domains/#{domain}"
```

**Add a domain:**

```ruby
result = @mg_client.post "domains", {:name => 'anothersample.mailgun.org',
                                     :smtp_password => 'super_secret',
                                     :spam_action => 'tag'}
```
**Delete a Domain: **

```ruby
result = @mg_client.delete "domains/#{domain}"
```
### Unsubscribes:
____________________________________________________
**Get List of Unsubscribes: **

```ruby
result = @mg_client.get "#{domain}/unsubscribes", {:limit => 50, :skip => 10}
```

**Get Single Unsubscribe: **

```ruby
result = @mg_client.get "#{domain}/unsubscribes/#{email_address}"
```

**Unsubscribe a Recipient: **

```ruby
result = @mg_client.post "#{domain}/unsubscribes", {:address => 'bob@example.com', :tag => 'mypromotion'}
```

**Unsubscribe from all messages for a domain: **

```ruby
result = @mg_client.post "#{domain}/unsubscribes", {:address => 'bob@example.com', :tag => '*'}
```

**Remove an unsubscribe: **

```ruby
result = @mg_client.delete "#{domain}/unsubscribes/#{email_address}"
```

### Complaints:
____________________________________________________
**Get List of Complaints: **

```ruby
result = @mg_client.get "#{domain}/complaints", {:limit => 50, :skip => 10}
```

**Get a Single Complaint: **

```ruby
result = @mg_client.get "#{domain}/complaints/#{email_address}"
```
**Create a complaint: **

```ruby
result = @mg_client.post "#{domain}/complaint", {:address => 'bob@example.com'}
```

**Remove a complaint: **

```ruby
result = @mg_client.delete "#{domain}/complaint/#{email_address}"
```

### Bounces:
____________________________________________________
**Get List of Bounces: **

```ruby
result = @mg_client.get "#{domain}/bounces", {:limit => 50, :skip => 10}
```

**Get a Single Bounce Event: **

```ruby
result = @mg_client.get "#{domain}/bounces/#{email_address}"
```

**Create a Bounce: **

```ruby
result = @mg_client.post "#{domain}/bounces", {:address => 'bob@example.com',
                                               :code => 550,
                                               :error => 'Mailbox does not exist.'}
```

**Remove a Bounced Address: **

```ruby
result = @mg_client.delete "#{domain}/bounces/#{email_address}"
```

### Statistics:
____________________________________________________
**Get Statistics: **

```ruby
result = @mg_client.get "#{domain}/stats", {:limit => 50,
                                            :skip => 10,
                                            :event => 'sent',
                                            "start-date" => 'Mon, 13 Feb 2015 00:00:00 GMT'}
```

**Remove a Tag: **

```ruby
result = @mg_client.delete "#{domain}/tags/#{tag}"
```
### Events:
____________________________________________________
**Get Event: **

```ruby
result = @mg_client.get "#{domain}/events", {:event => 'rejected'}
```

### Routes:
____________________________________________________
**Get List of Routes: **

```ruby
result = @mg_client.get "routes", {:limit => 50, :skip => 10}
```

**Get a Single Route by ID: **

```ruby
result = @mg_client.get "routes/#{route_id}"
```
**Create a Route: **

```ruby
result = @mg_client.post "routes",  {:priority => 10,
                                     :description => 'This is a test route',
                                     :expression => 'match_recipient(".*@gmail.com")',
                                     :action => 'forward("alice@example.com")'}
```
**Update a Route: **

```ruby
result = @mg_client.put "routes/#{route_id}",  {:priority => 10,
                                                :description => 'This is a test route',
                                                :expression => 'match_recipient(".*@gmail.com")',
                                                :action => 'forward("alice@example.com")'}
```
**Remove a Route: **

```ruby
result = @mg_client.delete "routes/#{route_id}"
```
### Campaigns:
____________________________________________________
**Get List of Campaigns: **

```ruby
result = @mg_client.get "#{domain}/campaigns", {:limit => 50, :skip => 10}
```

**Get a Single Campaign: **

```ruby
result = @mg_client.get "#{domain}/campaigns/#{campaign_id}"
```

**Create a Campaign: **

```ruby
result = @mg_client.post "#{domain}/campaigns", {:name => 'My Campaign',
                                                 :id => 'campaign_123_2014'}
```

**Update a Campaign: **

```ruby
result = @mg_client.put "#{domain}/campaigns/#{campaign_id}", {:name => 'My Campaign',
                                                               :id => 'campaign_123_2014'}
```

**Remove a Campaign: **

```ruby
result = @mg_client.delete "#{domain}/campaigns/#{campaign_id}"
```

**Get Campaign Events: **

```ruby
result = @mg_client.get "#{domain}/campaigns/#{campaign_id}/events", {:event => 'clicked',
                                                                      :recipient => 'test@example.com',
                                                                      :country => 'US',
                                                                      :region => 'TX',
                                                                      :limit => 100,
                                                                      :page => 1,
                                                                      :count => true}
```

**Get a Single Campaign's Stats: **

```ruby
result = @mg_client.get "#{domain}/campaigns/#{campaign_id}/stats", {:groupby => 'domain'}
```

**Get a Single Campaign's Click Stats: **

```ruby
result = @mg_client.get "#{domain}/campaigns/#{campaign_id}/clicks", {:groupby => 'hour',
                                                                      :country => 'US',
                                                                      :region => 'TX',
                                                                      :city => 'Austin',
                                                                      :limit => 100,
                                                                      :page => 1,
                                                                      :count => true}
```

**Get a Single Campaign's Click Opens: **

```ruby
result = @mg_client.get "#{domain}/campaigns/#{campaign_id}/opens", {:groupby => 'hour',
                                                                     :country => 'US',
                                                                     :region => 'TX',
                                                                     :city => 'Austin',
                                                                     :limit => 100,
                                                                     :page => 1,
                                                                     :count => true}
```

**Get a Single Campaign's Click Unsubscribes: **

```ruby
result = @mg_client.get "#{domain}/campaigns/#{campaign_id}/unsubscribes", {:groupby => 'hour',
                                                                            :country => 'US',
                                                                            :region => 'TX',
                                                                            :city => 'Austin',
                                                                            :limit => 100,
                                                                            :page => 1,
                                                                            :count => true}
```

**Get a Single Campaign's Click Complaints: **

```ruby
result = @mg_client.get "#{domain}/campaigns/#{campaign_id}/complaints", {:groupby => 'hour',
                                                                          :limit => 100,
                                                                          :page => 1,
                                                                          :count => true}
```

### Webhooks:
____________________________________________________

**Get List of Webhooks: **

```ruby
result = @mg_client.get "domains/#{domain}/webhooks"
```

**Get a Webhook Properties: **

```ruby
result = @mg_client.get "domains/#{domain}/webhooks/#{webhook_id}"
```

**Create a Webhook: **

```ruby
result = @mg_client.post "domains/#{domain}/webhooks", {:id => 'bounce',
                                                        :url => 'http://example.com/mailgun/events/bounce'}
```

**Update a Webhook: **

```ruby
result = @mg_client.put "domains/#{domain}/webhooks/#{webhook_id}", {:id => 'bounce',
                                                                     :url => 'http://example.com/mailgun/events/bounce'}
```

**Remove a Webhook: **

```ruby
result = @mg_client.delete "domains/#{domain}/webhooks/#{webhook_id}"
```

### Mailing Lists:
____________________________________________________

**Get list of Lists: **

```ruby
result = @mg_client.get "lists"
```

**Get List Properties: **

```ruby
result = @mg_client.get "lists/#{list_address}"
```

**Create a List: **

```ruby
result = @mg_client.post "lists", {:address => 'dev.group@samples.mailgun.org',
                                   :name => 'Development Group List',
                                   :description => 'List of all developers.',
                                   :access_level => 'members'}
```

**Update a List: **

```ruby
result = @mg_client.put "lists/#{list_address}", {:address => 'dev.group@samples.mailgun.org',
                                                  :name => 'Development Group List',
                                                  :description => 'List of all developers.',
                                                  :access_level => 'members'}
```

**Remove a List: **

```ruby
result = @mg_client.delete "lists/#{list_address}"
```

**Get List Members: **

```ruby
result = @mg_client.get "lists/#{list_address}/members"
```

**Get List Member Properties: **

```ruby
result = @mg_client.get "lists/#{list_address}/members/#{member_address}"
```

**Add Member to List: **

```ruby
result = @mg_client.post "lists/#{list_address}/members/#{member_address}", {:address => 'jane@samples.mailgun.org',
                                                                             :name => 'Jane Doe',
                                                                             :vars => '{"first": "Jane", "last": "Doe"}',
                                                                             :subscribed => true,
                                                                             :upsert => 'no'}
```

**Update Member on List: **

```ruby
result = @mg_client.put "lists/#{list_address}/members/#{member_address}", {:address => 'jane@samples.mailgun.org',
                                                                             :name => 'Jane Doe',
                                                                             :vars => '{"first": "Jane", "last": "Doe"}',
                                                                             :subscribed => true}
```

**Delete a Member from List: **

```ruby
result = @mg_client.delete "lists/#{list_address}/members/#{member_address}"
```

**Get Stats for List: **

```ruby
result = @mg_client.get "lists/#{list_address}/stats"
```

### Email Validation:
____________________________________________________
**Validate Single Address: **

```ruby
result = @mg_client.get "address/validate", {:address => 'test@example.com'}
```

**Parse Addresses: **

```ruby
result = @mg_client.get "address/parse", {:addresses => 'test@example.com, "First Last <first.last@example.com>',
                                          :syntax_only => true}
```


Support and Feedback
--------------------

Be sure to visit the Mailgun official
[documentation website](https://documentation.mailgun.com/) for additional
information about our API.

If you find a bug, please submit the issue in Github directly.
[Mailgun-Ruby Issues](https://github.com/mailgun/Mailgun-PHP/issues)

As always, if you need additional assistance, drop us a note at
[support@mailgun.com](mailto:support@mailgun.com).
