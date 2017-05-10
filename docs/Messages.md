Mailgun - Messages
====================

This is the Mailgun Ruby *Message* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions.

There are two utilities included, Message Builder and Batch Message.

Message Builder: Allows you to build a message object by calling methods for
each MIME attribute.
Batch Message: Inherits Message Builder and allows you to iterate through
recipients from a list. Messages will fire after the 1,000th recipient has been
added.

Usage - Message Builder
-----------------------
Here's how to use Message Builder to build your Message.

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new("your-api-key")
mb_obj = Mailgun::MessageBuilder.new

# Define the from address.
mb_obj.set_from_address("me@example.com", {"first"=>"Ruby", "last" => "SDK"})

# Define a to recipient.
mb_obj.add_recipient(:to, "john.doe@example.com", {"first" => "John", "last" => "Doe"})

# Define a cc recipient.
mb_obj.add_recipient(:cc, "sally.doe@example.com", {"first" => "Sally", "last" => "Doe"})

# Define the subject.
mb_obj.set_subject("A message from the Ruby SDK using Message Builder!")

# Define the body of the message.
mb_obj.set_text_body("This is the text body of the message!")

# Define the HTML text of the message
mb_obj.set_html_body("<html><body><p>This is the text body of the message</p></body></html>")

# Set the Message-Id header. Pass in a valid Message-Id.
mb_obj.set_message_id("<20141014000000.11111.11111@example.com>")

# Clear the Message-Id header. Pass in nil or empty string.
mb_obj.set_message_id(nil)
mb_obj.set_message_id('')

# Other Optional Parameters.
mb_obj.add_campaign_id("My-Awesome-Campaign")
mb_obj.header("Customer-Id", "12345")
mb_obj.add_attachment("./tron.jpg")
mb_obj.set_delivery_time("tomorrow 8:00AM PST")
mb_obj.set_click_tracking(true)

# Send your message through the client
mg_client.send_message("sending_domain.com", mb_obj)
```

Usage - Batch Message
---------------------
Here's how to use Batch Message to easily handle batch sending jobs.

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new("your-api-key")
mb_obj = Mailgun::BatchMessage.new(mg_client, "example.com")

# Define the from address.
mb_obj.set_from_address("me@example.com", {"first"=>"Ruby", "last" => "SDK"})

# Define the subject.
mb_obj.set_subject("A message from the Ruby SDK using Message Builder!")

# Define the body of the message.
mb_obj.set_text_body("Hello %recipient.first%,
                     This is the text body of the message
                     using recipient variables!
                     If you need to include custom data,
                     you could do it like this: %recipient.account-id%.")

mb_obj.add_recipient(:to, "john.doe@example.com", {"first"      => "John",
                                                   "last"       => "Doe",
                                                   "account-id" => 1234})

mb_obj.add_recipient(:to, "jane.doe@example.com", {"first"      => "Jane",
                                                   "last"       => "Doe",
                                                   "account-id" => 5678})

mb_obj.add_recipient(:to, "bob.doe@example.com", {"first"       => "Bob",
                                                  "last"        => "Doe",
                                                  "account-id"  => 91011})
...
mb_obj.add_recipient(:to, "sally.doe@example.com", {"first"      => "Sally",
                                                    "last"       => "Doe",
                                                    "account-id" => 121314})

# Send your message through the client
message_ids = mb_obj.finalize
```

More Documentation
------------------
See the official [Mailgun Docs](https://documentation.mailgun.com/api-sending.html)
for more information.
