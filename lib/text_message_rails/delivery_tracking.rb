module TextMessage

  module DeliveryTracking

    module ClassMethods

      # Returns a list of past deliveries.
      #
      # This simple implementation uses a simple array to store past +TextMessage::Delivery+ instances.
      # Can be overridden in subclasses to provide orher strategy (DB queries etc.)
      def deliveries
        @@deliveries ||= []
      end

      # Adds an entry to the list of past deliveries.
      #
      # This simple implementation uses a simple array to store past +TextMessage::Delivery+ instances.
      # Can be overridden in subclasses to provide orher strategy (DB queries etc.)
      def track_delivery(sms)
        deliveries.append(sms)
      end

    end

    def self.included(klass) #:nodoc:
      klass.extend(ClassMethods)
    end

  end

end
