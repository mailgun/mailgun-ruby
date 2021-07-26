Mailgun - Templates
====================

This is the Mailgun Ruby *Template* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions. It currently supports
all calls.

Usage - Templates
-----------------------

```ruby
# First, instantiate the Mailgun Client with your API key
mg_client = Mailgun::Client.new('your-api-key')
templates = Mailgun::Templates.new(mg_client, 'my.domain')

# Get a list templates for a domain.
templates.list

# Add a template
template = <<-TEMPLATE
  <p>Hi {{first_name}}</p>
  <p>You have been invited to join our platform</p>
  <p><a href="{{url}}">Click here</a></p>
TEMPLATE

templates.create 'invitation.template', 'Used to invite members to the platform', template

# View a single template detail
templates.info 'invitation.template'

# Update the description of the template
templates.update 'invitation.template', 'Invitation to the platform'

# Create a new version of the template
template = <<-TEMPLATE
  <p>Hey {{first_name}}!</p>
  <p>You have been invited to join our awesome platform</p>
  <p><a href="{{url}}">Click here to join the party!</a></p>
TEMPLATE

templates.add_version 'invitation.template', template, 'v2', active: 'yes'

# Remove a template
templates.delete 'invitation.template'
```

More Documentation
------------------
See the official [Mailgun Template Docs](https://documentation.mailgun.com/en/latest/api-templates.html)
for more information
