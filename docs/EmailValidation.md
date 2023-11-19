Mailgun - Email Validation
====================

This is the Mailgun Ruby *Email Validation* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions.

Usage - Email Validation
-----------------------

```ruby
# First, instantiate the Mailgun Address. It pulls api key for Client from Mailgun.api_key variable.
email_validator = Mailgun::Address.new

# Given an arbitrary address, validates address based off defined checks.
# Response Example:
# {
#     "address": "existingemail@realdomain.com",
#     "is_disposable_address": false,
#     "is_role_address": false,
#     "reason": [],
#     "result": "deliverable",
#     "risk": "low"
# }
email_validator.validate('email@example.com')


```

More Documentation
------------------
See the official [Mailgun Email Validation Docs](https://documentation.mailgun.com/en/latest/api-email-validation.html)
for more information
