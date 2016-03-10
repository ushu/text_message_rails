module TextMessage
  module Providers

    class TextMagic < Base
      def deliver_text_message
        client.send(message, *escaped_recipients, options)
      end

      def escaped_recipients
        return recipients unless defined?(PhonyRails)

        Array(recipients).map { |recipient|
          PhonyRails.normalize_number(recipient, format: :international_relative, spaces: '', add_plus: false)
        }

      end

      def client
        @client ||= TextMagic::API.new(username, password)
      end

      private

      def username
        options[:username] || ENV["TEXTMAGIC_USERNAME"]
      end

      def password
        options[:password] || ENV["TEXTMAGIC_PASSWORD"]
      end
    end

  end
end

