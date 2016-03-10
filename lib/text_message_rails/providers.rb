module TextMessage
  module Providers
    class Error < StandardError; end

    def self.find(name)
      "TextMessage::Providers::#{name.to_s.camelize}".constantize
    end

    class Base
      attr_reader :delivery
      attr_reader :options

      def self.deliver_text_message(delivery, options={})
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
    autoload :TextMagic, "text_message_rails/providers/text_magic" if defined?(::TextMagic)
  end
end
