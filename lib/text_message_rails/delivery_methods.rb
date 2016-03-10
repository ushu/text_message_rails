module TextMessage

  # = TextMessage Delivery Methods
  module DeliveryMethods

    # Defivers a TextMessage
    def deliver_now!
      @text_message_class.deliver_text_message(self)
      @text_message_class.track_delivery(self)
    end

    # Posts a ActionJob job to call +deliver_now!+ later
    def deliver_later!(options={})
      enqueue_delivery :deliver_now!, options
    end

    private

    # Enqueues a delivery
    # +options+ are passed to ActiveJob.
    # +delivery_method+ (usually +deliver_now!+ is called with the saved +@args+ on time.
    def enqueue_delivery(delivery_method, options={})
      args = @text_message_class.name, @text_message_method.to_s, delivery_method.to_s, *@args
      ::TextMessage::DeliveryJob.set(options).perform_later(*args)
    end

  end

end
