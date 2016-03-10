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
      @view_context ||= TemplateContext.new(renderer, view_assigns, self)
    end

    # Simple out-of-the box ActionView::Renderer
    def renderer #:nodoc:
      @renderer ||= ActionView::Renderer.new(lookup_context)
    end


    #
    # Private class to render provide rendering context with helpers
    #

    class TemplateContext < ActionView::Base #:nodoc:
      # Load route helpers
      include Rails.application.routes.url_helpers
      # load tag helpers (link_to ...)
      include ActionView::Helpers::TagHelper

      # Default options for urls
      def default_url_options
        TextMessage::Base.default_url_options.merge({
          #action: action_name,
          #controller: controller.class.name.underscore
        })
      end
    end

  end

end
