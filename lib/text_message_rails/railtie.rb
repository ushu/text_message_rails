require "rails"

module TextMessage
  class Railtie < Rails::Railtie
    config.text_message = ActiveSupport::OrderedOptions.new

    initializer "text_message.configure" do |app|
      # Update load paths
      app.config.paths.add "app/text_messages", eager_load: true

      # Load plugin-specific options
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
