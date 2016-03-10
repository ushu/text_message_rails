module TextMessage

  # = TextMessage Delivery Proxy
  # The +Delivery+ class is the class returned by the +TextMessage::Base+ actions.
  # It is used to enable lazy processing of the actions.
  class Delivery < Delegator

    include ::TextMessage::DeliveryMethods

    # Creates a new +Delivery+ proxy.
    # By providing a +TextMessage::Base+ subclass +text_message_class+, a method name to call
    # +text_message_method+ and a set of arguments to this method +args+, we allow
    # for lazy processing of the text_message action.
    def initialize(text_message_controller, text_message_method, *args)
      if text_message_controller.kind_of?(TextMessage::Controller)
        @obj = text_message_controller
        @text_message_class = @obj.class
      else
        @text_message_class = text_message_controller.kind_of?(Class) ? text_message_controller : text_message_controller.constantize
      end
      @text_message_method = text_message_method
      @args = args
    end

    # Needed by Decorator superclass
    def __getobj__ #:nodoc:
      @obj ||= @text_message_class.send(:new, @text_message_method, *@args)
    end

    # computes the body of the TextMessage
    def body
      @body ||= renderer.render(view_context, template: "#{templates_dir}/#{@text_message_method}")
    end

    # The name of the templates which holds the templates.
    # Usually it is the name of the class with underscores, something like:
    #
    #   TextMessageDemo.new.templates_dir => "text_message demo"
    #   # so for exemple TextMessageDemo#toto will lookup for text_message_demo/toto{.text.erb}
    def templates_dir
      @text_message_class.name.to_s.underscore
    end

  end

end
