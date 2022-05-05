# frozen_string_literal: true

module Rack
  module Handler
    # Rack handler for SimpleWebServer
    class SimpleWebServer
      # @param app [#call] Rack middleware
      # @param _options [kargs]
      def self.run(app, **_options)
        serve(app)
      end
    end
  end
end
