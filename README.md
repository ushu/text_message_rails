# text_message_rails

A simple gem to send text messages from rails

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'text-message-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install text-message-rails

## Usage

A base text message sender must be created, as follows:

```ruby
class ApplictionTextMessages < TextMessage::Controller

  # This method is called with the TextMessage::Delivery as an argument
  def self.deliver_text_message(text_message)
    message = text_message.body.to_str
    recipients = text_message.recipients.map(&:to_str)

    unless recipients.empty?
      TextMessageService.send_message(message, to: recipients)
    end
  end

end
```

Then the sub-classes can be used in a similar way as ActionMailer::Base objects:

```ruby
class ClientTextMessages < ApplicationTextMessages

  def confirm_order(order)
    @order = order
    @user = @order.user

    # ...

    phone_number = user.phone_number
    send_to phone_number
  end

end
```

```erb
<%# in app/views/client_text_messages/confirm_order.text.erb %>
Dear <%= user.name %> your order <%= order.id %> is confirmed !
```

in a different class:

```ruby
ClientTextMessages.confirm_order(order).deliver_now!
# or
ClientTextMessages.confirm_order(order).deliver_later!
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/text-message-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

