# text_message_rails

**DEPRECATED: this gem is not maintained anymore, use at you own risks !**

A simple gem to send text messages from rails

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'text_message_rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install text_message_rails

## Usage

In your application config, define the provider you want ot use (for now on,
only TextMagic is supported):

```ruby
config.text_message.provider = :text_magic
```

Then create instances of the `TextMessage::Controller`:


```ruby
class ClientTextMessages < TextMessage::Controller

  def confirm_order(order)
    @order = order
    @user = @order.user

    # ...

    phone_number = user.phone_number
    send_to phone_number
  end

end
```

And associated view(s):

```erb
<%# in app/views/client_text_messages/confirm_order.text.erb %>
Dear <%= user.name %> your order <%= order.id %> is confirmed !
```

Then from a different class, call:

```ruby
ClientTextMessages.confirm_order(order).deliver_now!
# or
ClientTextMessages.confirm_order(order).deliver_later!
```

## Provider

For the time being, only the `TextMagic` provider is supported.

### TextMagic

To use it, include it in you `Gemfile`:

```ruby
# include the API gem
gem "text_magic"

# (optional but recommanded) include Phony Rails so the provider will reformat
# the phone number in TextMagic-friendly way:
gem "phony_rails"
```

Enable its use in the configuration:

```ruby
config.text_message.provider = :text_magic
```

And provision the following environment variables:

```yaml
TEXTMAGIC_USERNAME: "my textmagic user name"
TEXTMAGIC_PASSWORD: "my textmagic password"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/text_message_rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

