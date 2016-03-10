module TextMessage

  autoload :VERSION, "text_message_rails/version"

  autoload :Controller, "text_message_rails/controller"
  autoload :Delivery, "text_message_rails/delivery"
  autoload :DeliveryJob, "text_message_rails/delivery_job"
  autoload :DeliveryMethods, "text_message_rails/delivery_methods"
  autoload :Rendering, "text_message_rails/rendering"
  autoload :Providers, "text_message_rails/providers"

end

require "text_message_rails/railtie" if defined?(::Rails::Railtie)
