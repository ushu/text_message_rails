require "rails"

module TextMessage
  class Railtie < Rails::Railtie
    config.text_message = ActiveSupport::OrderedOptions.new

    initializer "text_message.configure" do |app|
      app_options = app.config.text_message

      if default_url_options = app_options.default_url_options
        TextMessage::Controller.default_url_options = default_url_options
      end

      if provider_key = app_options.provider
        TextMessage::Controller.provider = TextMessage::Providers.find(provider_key)
      end
    end
  end
end
