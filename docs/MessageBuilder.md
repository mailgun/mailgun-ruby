Mailgun - Messages
====================

This is the Mailgun Ruby *Message* utilities.

The below assumes you've already installed the Mailgun Gem. If not, go back to the master README for instructions.

There are two utilities included, Message Builder and Batch Message.

Message Builder: Allows you to build a message object by calling methods for
each attribute.
Batch Message: Inherits Message Builder and allows you to iterate through
recipients from a list. Messages will fire after the 1,000th recipient has been
added.

Usage - Message Builder
-----------------------
Here's how to use Message Builder to build your Message.

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new("your-api-key")
mb_obj = Mailgun::MessageBuilder.new()

# Define the from address.
mb_obj.from("me@example.com", {"first"=>"Ruby", "last" => "SDK"});

# Define a to recipient.
mb_obj.add_recipient(:to, "john.doe@example.com", {"first" => "John", "last" => "Doe"});

# Define a cc recipient.
mb_obj.add_recipient(:cc, "sally.doe@example.com", {"first" => "Sally", "last" => "Doe"});

# Define the subject.
mb_obj.subject("A message from the Ruby SDK using Message Builder!");

# Define the body of the message.
mb_obj.body_text("This is the text body of the message!");

# Set the Message-Id header, provide a valid Message-Id.
mb_obj.message_id("<20141014000000.11111.11111@example.com>")

# Or clear the Message-Id header, provide nil or empty string.
mb_obj.message_id(nil)
mb_obj.message_id('')

# Campaigns and headers.
mb_obj.add_campaign_id("My-Awesome-Campaign");
mb_obj.header("Customer-Id", "12345");

# Custom variables
mb_obj.variable("Customer-Data", { :first_name => "John", :last_name => "Smith" })

# Attach a file and rename it.
mb_obj.add_attachment "/path/to/file/receipt_123491820.pdf", "Receipt.pdf"

# Attach an image inline.
mb_obj.add_inline_image "/path/to/file/header.png"

# Schedule message in the future
mb_obj.deliver_at("tomorrow 8:00AM PST");

# Finally, send your message using the client
result = mg_client.send_message("sending_domain.com", mb_obj)

puts result.body.to_s
```

Usage - Batch Message
---------------------
Here's how to use Batch Message to easily handle batch sending jobs.

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new("your-api-key")

# Create a Batch Message object, pass in the client and your domain.
mb_obj = Mailgun::BatchMessage.new(mg_client, "example.com")

# Define the from address.
mb_obj.from("me@example.com", {"first" => "Ruby", "last" => "SDK"});

# Define the subject.
mb_obj.subject("A message from the Ruby SDK using Message Builder!");

# Define the body of the message.
mb_obj.body_text("This is the text body of the message!");


# Loop through all of your recipients
mb_obj.add_recipient(:to, "john.doe@example.com", {"first" => "John", "last" => "Doe"});
mb_obj.add_recipient(:to, "jane.doe@example.com", {"first" => "Jane", "last" => "Doe"});
mb_obj.add_recipient(:to, "bob.doe@example.com", {"first" => "Bob", "last" => "Doe"});
...
mb_obj.add_recipient(:to, "sally.doe@example.com", {"first" => "Sally", "last" => "Doe"});

# Call finalize to get a list of message ids and totals.
message_ids = mb_obj.finalize
# {'id1234@example.com' => 1000, 'id5678@example.com' => 15}
```

More Documentation
------------------
See the official [Mailgun Docs](http://documentation.mailgun.com/api-sending.html)
for more information.
