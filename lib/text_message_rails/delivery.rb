module TextMessage

  # = TextMessage Delivery Proxy
  # The +Delivery+ class is the class returned by the +TextMessage::Base+ actions.
  # It is used to enable lazy processing of the actions.
  class Delivery < Delegator

    include ::TextMessage::DeliveryMethods

    # Creates a new +Delivery+ proxy.
    # By providing a +TextMessage::Base+ subclass +sms_class+, a method name to call
    # +sms_method+ and a set of arguments to this method +args+, we allow
    # for lazy processing of the sms action.
    def initialize(sms_class, sms_method, *args)
      @sms_class = sms_class.kind_of?(Class) ? sms_class : sms_class.constantize
      @sms_method = sms_method
      @args = args
    end

    # Needed by Decorator superclass
    def __getobj__ #:nodoc:
      @obj ||= @sms_class.send(:new, @sms_method, *@args)
    end

    # computes the body of the TextMessage
    def body
      renderer.render(view_context, template: "#{templates_dir}/#{@sms_method}")
    end

    # The name of the templates which holds the templates.
    # Usually it is the name of the class with underscores, something like:
    #
    #   TextMessageDemo.new.templates_dir => "sms demo"
    #   # so for exemple TextMessageDemo#toto will lookup for sms_demo/toto{.text.erb}
    def templates_dir
      @sms_class.to_s.underscore
    end

  end

end
