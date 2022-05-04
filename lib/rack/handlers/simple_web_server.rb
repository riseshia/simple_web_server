# frozen_string_literal: true

module Rack
  module Handler
    # Rack handler for SimpleWebServer
    module SimpleWebServer
      module_function

      # @param app [#call] Rack middleware
      # @param _options [kargs]
      def run(app, **_options)
        serve(app)
      end
    end
  end
end
