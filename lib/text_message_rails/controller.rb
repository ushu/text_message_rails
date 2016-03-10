require "abstract_controller"

module TextMessage

	# = TextMessage controller base class
	# This class acts as a controller, similar to +ActionMailer::Controller+ subclasses.
	# To use it:
	#
	#  - implement action methods as in a "usual" controller
	#  - implement the deliver_text_message that will receive the rendered sms instance to send
	#
	#   class TextMessageTest < TextMessage::Controller
	#
	#     # Will render app/views/sms_test/toto.(...), passing it the instance variables
	#     def toto
	#       @tutu = 4
	#     end
	#
	#     def self.deliver_text_message(sms)
	#       sms_text = sms.body
	#       puts "delivering TextMessage: #{sms_text}"
	#       #...
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

		# Instanciate a new TextMessage object.
		#
		# Then calls +method_name+ with the given +args+.
		def initialize(method_name, *args)
			@recipients = []
			super()
			process(method_name, *args)
		end

		# Basic Recipients handling
		attr_reader :recipients
		def send_to(*recipients)
			@recipients = recipients || []
		end

		class << self
      attr_accessor :default_url_options

      # Reuses ActionMailer url options by default
      def default_url_options
        super || ActionMailer::Base.default_url_options
      end

      attr_accessor :provider

      # Defaults provider to the Base (empty) provider: will raise !
      def provider
        super || Providers::Base
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
        provder.deliver_text_message(delivery)
      end
		end
	end

end


