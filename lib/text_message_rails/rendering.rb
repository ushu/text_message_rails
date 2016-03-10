require "rails"

module TextMessage

  # = TextMessage Rendering methods
  module Rendering

    def self.included(klass) #:nodoc:
      # setup the view path: will lookup templates in view_paths/template_name
      klass.view_paths = "app/views"
    end

    # Called internally by #render
    def render_to_body(options={}) #:nodoc:
      renderer.render(view_context, options)
    end

    # Use custom rendeing class with helpers loaded
    def view_context # :nodoc:
      @view_context ||= if defined?(ApplicationController)
                          ApplicationController.view_context_class.new(renderer, view_assigns, self)
                        else
                           TemplateContext.new(renderer, view_assigns, self)
                         end
    end

    # Simple out-of-the box ActionView::Renderer
    def renderer #:nodoc:
      @renderer ||= ActionView::Renderer.new(lookup_context)
    end


    #
    # Private class to render provide rendering context with helpers
    # (when there is no ApplicationController: rails API etc.)
    #

    class TemplateContext < ActionView::Base #:nodoc:
      # Load route helpers
      include Rails.application.routes.url_helpers
      # load tag helpers (link_to ...) and all relevant default helpers
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::DateHelper
      include ActionView::Helpers::NumberHelper
      include ActionView::Helpers::TextHelper
      include ActionView::Helpers::TranslationHelper

      # Default options for urls
      def default_url_options
        TextMessage::Controller.default_url_options
      end
    end

  end

end
