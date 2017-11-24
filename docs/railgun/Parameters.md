Parameters
==========

When sending messages via Railgun, it is often useful to set options, headers, and variables
that should be added to the `POST` request against the messages endpoint.


## Options

See [Mailgun Docs | Sending](https://documentation.mailgun.com/en/latest/api-sending.html#sending) for available options.

---

To set options on a message:

```ruby
# app/controllers/some_controller.rb

message = YourMailer.your_message(@args)

message.mailgun_options ||= {
  "tracking-opens" => "true",
  "tracking-clicks" => "htmlonly",
  "tag" => "some,tags",
}
```


## Variables

See [Mailgun Docs | Attaching Data to Messages](https://documentation.mailgun.com/en/latest/user_manual.html#attaching-data-to-messages) for more information.

---

To set variables on a message:

```ruby
# app/controllers/some_controller.rb

message = YourMailer.your_message(@args)

message.mailgun_variables ||= {
  "user_info" => {"id" => "1", "name" => "tstark"},
}
```


## Headers

See [Mailgun Docs | Sending](https://documentation.mailgun.com/en/latest/api-sending.html#sending) for more information.

---

To set headers on a message *from a controller*:

```ruby
# app/controllers/some_controller.rb

message = YourMailer.your_message(@args)

message.mailgun_headers ||= {
  "X-Sent-From-Rails" => "true",
}
```

To set headers on a message *from a mailer*:

```ruby
# app/mailers/your_mailer.rb

class YourMailer < ApplicationMailer
  # ...

  def your_message(args)
    headers({
      "X-Sent-From-Rails" => "true",
    })

    mail to: "some-address@example.org", ...
  end

end
```
