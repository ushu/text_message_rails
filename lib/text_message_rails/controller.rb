require "abstract_controller"

module TextMessage

	# = TextMessage controller base class
	# This class acts as a controller, similar to +ActionMailer::Controller+ subclasses.
  #
	# To use it implement action methods as in a mailer:
	#
	#   class TextMessageTest < TextMessage::Controller
	#
	#     # Will render app/views/sms_test/toto.(...), passing it the instance variables
	#     def toto
	#       @tutu = 4
	#     end
	#
	#   end
	class Controller < AbstractController::Base

		# Load tons of AbstractController plugins
		include AbstractController::Rendering
		include AbstractController::Logger
		include AbstractController::Helpers
		include AbstractController::Callbacks

		# Defines #render_to_body, needed by #render.
		include ::TextMessage::Rendering

    attr_reader :params

		# Instanciate a new TextMessage object.
		#
		# Then calls +method_name+ with the given +args+.
		def initialize(method_name, *params)
			@recipients = []
      @params = params
			super()
			process(method_name, *params)
		end

		# Basic Recipients handling
		attr_reader :recipients
		def send_to(*recipients)
			@recipients = recipients || []
		end

    def delivery
      TextMessage::Delivery.new(self, action_name, *params)
    end

		class << self

      def default_url_options=(options)
        @@default_url_options =  options
      end
      # Reuses ActionMailer url options by default
      def default_url_options
        @@default_url_options || ActionMailer::Base.default_url_options
      end

      def provider=(p)
        @@provider = p
      end
      # Defaults provider to the Base (empty) provider: will raise !
      def provider
        @@provider || TextMessage::Providers::Base
      end

			# Respond to the action methods directly on the class
			#
			# for example calling `TextMessageDemo.toto` (with TextMessageDemo a subclass of +TextMessage::Controller+)
			# will create a +TextMessage::Delivery+ instance tied to the `TextMessageDemo` class,
			# method `:toto` with no argument.

			def respond_to?(method, include_private = false) #:nodoc:
				super || action_methods.include?(method.to_s)
			end

			def method_missing(method_name, *args) #:nodoc:
				if action_methods.include?(method_name.to_s)
					TextMessage::Delivery.new(self, method_name, *args)
				else
					super
				end
			end

      def deliver_text_message(delivery)
        provider.deliver_text_message(delivery)
      end
		end
	end

end
