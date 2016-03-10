module TextMessage
  module Providers
    class Error < StandardError; end

    def self.find(name)
      provider_name = name.to_s.camelize.to_sym
      ::TextMessage::Providers.const_get(provider_name)
    end

    class Base
      attr_reader :delivery
      attr_reader :options

      def self.deliver_text_message(delivery, options)
        new(delivery, options).deliver_text_message
      end

      def initialize(delivery, options={})
        @delivery = delivery
        @options  = options
      end

      def deliver_text_message
        raise Error.new("no provider configured")
      end

      def message
        delivery.body.to_str
      end

      def recipients
        delivery.recipients.map(&:to_str)
      end
    end

    # Known providers
    autoload :TextMagicProvider, "text_message_rails/providers/text_magic" if defined?(TextMagic)
  end
end
