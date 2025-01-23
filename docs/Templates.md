Mailgun - Templates
====================

This is the Mailgun Ruby *Templates* utilities.

The below assumes you've already installed the Mailgun Ruby SDK in to your
project. If not, go back to the master README for instructions.

Usage - Templates
-----------------------

**Build a message with a template:**

```ruby
mb_obj = Mailgun::MessageBuilder.new

mb_obj.from("sender@example.com")
mb_obj.add_recipient("to", "recipient@example.com")
mb_obj.subject ("This is the subject!")
message.template('example.template.name')
message.template_version('example.tag')

mg_client.send_message "sending_domain.com", mb_obj
```

**Rails Example. Build a message with a template:**

```ruby
class UserMailer < ApplicationMailer
  def welcome_email
    message = mail(
    	from: "sender@example.com",
    	to: "recipient@example.com",
    	subject: "This is the subject!",
    	template: 'example.template.name'
    ) do |format|
      format.text { render plain: "Test!" }
    end
    message.tap do |message|
      message.mailgun_template_variables ||= {
       'version' => 'example.tag'
      }
    end
  end
end
```

Template Handlebars
-------------------------

```
{{#if english}}
<p>This text is in the English language.</p>
{{else if spanish}}
<p>Este texto está en idioma español.</p>
{{else if french}}
<p>Ce texte est en langue française.</p>
{{/if}}
```

In order to send the spanish version, for example:

```ruby
message.variable('spanish', 'true')
```

Also, Rails example:

```ruby
class UserMailer < ApplicationMailer
  def welcome_email
    message = mail(
    	from: "sender@example.com",
    	to: "recipient@example.com",
    	subject: "This is the subject!",
    	template: 'example.template.name'
    ) do |format|
      format.text { render plain: "Test!" }
    end
    message.tap do |message|
      message.mailgun_variables ||= {
       'spanish' => 'true'
      }
    end
  end
end
```

More Documentation
------------------
See the official [Mailgun Templates Docs](https://documentation.mailgun.com/en/latest/api-templates.html)
for more information
