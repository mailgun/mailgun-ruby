Mailgun - Lists
====================

This is the Mailgun Ruby *Lists* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in your project.
If not, go back to the master README for a few quick install steps.

OptInHandler: Provides methods for authenticating an Opt-In Request.

The typical flow for using this utility would be as follows:
**Recipient Requests Subscribe** -> [Validate Recipient Address] -> [Generate Opt-In Link] -> [Email Recipient Opt-In Link]
**Recipient Clicks Opt-In Link** -> [Validate Opt-In Link] -> [Subscribe User] -> [Send final confirmation]

The above flow is modeled below.

Usage - Opt-In Handler (Recipient Requests Subscribe)
-----------------------------------------------------
Here's how to use Opt-In Handler to validate Opt-In requests.

```ruby
# First, instantiate the SDK with your API credentials, domain, and required parameters for example.
mg_client = Mailgun::Client.new("your-api-key")
mg_validate = Mailgun::Client.new("your-pub-api-key")

domain = 'example.com';

mailing_list = 'youlist@example.com';
secret_app_id = 'a_secret_passphrase';
recipient_address = 'recipient@example.com';

# Let's validate the customer's email address, using Mailgun's validation endpoint.
result = mg_validate.get('address/validate', {:address => recipient_address});
body = JSON.parse(result.body)

if body['is_valid'] == true
	# Next, generate a hash.
	generated_hash = Mailgun::OptInHandler.generate_hash(mailing_list, secret_app_id, recipient_address);
	
	# Now, let's send a confirmation to the recipient with our link.
	mg_client.send_message(domain, {:from    => 'bob@example.com',
	                                :to      => recipient_address,
	                                :subject => 'Please Confirm!',
	                                :html    => "<html><body>Hello,<br><br>You have requested to be subscribed
		                            to the mailing list #{mailing_list}. Please <a
		                            href=\"http://yourdomain.com/subscribe.php?hash=#{generated_hash}\">
		                            confirm</a> your subscription.<br><br>Thank you!</body></html>"});
	                                			  
	# Finally, let's add the subscriber to a Mailing List, as unsubscribed, so we can track non-conversions.
	mg_client.post("lists/#{mailing_list}/members", {:address    => recipient_address,
	                                		         :subscribed => 'no',
	                                			     :upsert     => 'yes'});
end
```

Usage - Opt-In Handler (Recipient Clicks Opt In Link)
-----------------------------------------------------
Here's how to use Opt-In Handler to validate an Opt-In Hash.

```ruby
# First, instantiate the SDK with your API credentials and domain.
mg_client = Mailgun::Client.new("your-api-key")
domain = 'example.com';

# Now, validate the captured hash.
hash_validation = Mailgun::OptInHandler.validate_hash(secret_app_id, inbound_hash);

# Lastly, check to see if we have results, parse, subscribe, and send confirmation.
if !hash_validation.nil?
	validated_list = hash_validation['mailing_list'];
	validated_recipient = hash_validation['recipient_address'];
	
	mg_client.put("lists/#{validated_list}/members/#{validated_recipient}",
							{:address    => validated_recipient,
	                         :subscribed => 'yes'})
    
    mg_client.send_message(domain, {:from    => 'bob@example.com',
                                    :to      => validated_recipient,
                                    :subject => 'Confirmation Received!',
                                    :html    => "<html><body>Hello,<br><br>We've successfully subscribed you to the list, #{validated_list}!<br><br>Thank you!
                                    </body></html>"});
end
```

A few notes:
1. 'secret_app_id' can be anything. It's used as the *key* in hashing,
since your email address will vary. It should be secured like a password.
2. validateHash will return an array containing the recipient address and list
address.
3. You should *always* send an email confirmation before and after the
subscription request. This is what double-opt in means.


Available Functions
-----------------------------------------------------

`string generate_hash(string mailing_list, string secret_app_id, string recipient_address)`

`array validate_hash(string secret_app_id, string unique_hash)`

More Documentation
------------------
See the official [Mailgun Docs](https://documentation.mailgun.com/api-sending.html) for more information.
