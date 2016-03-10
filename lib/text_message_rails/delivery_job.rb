module TextMessage

  # = TextMessage Deblivery Job
  # The +TextMessage::DeliveryJob+ class is used to defer text_message delivery through ActiveJob.
  class DeliveryJob < ActiveJob::Base #:nodoc:

    queue_as :text_messages

    # calls +deliver_now!+ on the text_message class
    def perform(text_message_class, text_message_method, delivery_method, *args)
      delivery = ::TextMessage::Delivery.new(text_message_class, text_message_method, *args)
      delivery.send(delivery_method)
    end
  end

end

