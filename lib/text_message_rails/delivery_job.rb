module TextMessage

  # = TextMessage Deblivery Job
  # The +TextMessage::DeliveryJob+ class is used to defer sms delivery through ActiveJob.
  class DeliveryJob < ActiveJob::Base #:nodoc:

    queue_as :sms

    # calls +deliver_now!+ on the sms class
    def perform(sms_class, sms_method, delivery_method, *args)
      delivery = ::TextMessage::Delivery.new(sms_class, sms_method, *args)
      delivery.send(delivery_method)
    end
  end

end

