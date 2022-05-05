# frozen_string_literal: true

module Rack
  # Rack::Handler
  module Handler
    # Rack handler for SimpleWebServer
    class SimpleWebServer
      # @param app [#call] Rack middleware
      # @param _options [kargs]
      def self.run(app, **_options)
        serve(app)
      end
    end

    register :simple_web_server, ::Rack::Handler::SimpleWebServer
  end
end
