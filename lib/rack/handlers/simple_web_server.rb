# frozen_string_literal: true

module Rack
  # Rack::Handler
  module Handler
    # Rack handler for SimpleWebServer
    class SimpleWebServer
      # @param app [#call] Rack middleware
      # @param _options [kargs]
      def self.run(app, **_options)
        @app = app
      end

      # @param raw_request [IO]
      # @return [String] response message
      def self.process(raw_request)
        req = ::SimpleWebServer::RequestParser.parse(raw_request)
        res = ::SimpleWebServer::Response.new

        res.from_call(*@app.call(req.to_env))
        res.http_version = req.http_version

        ::SimpleWebServer::ResponseBuilder.build(res)
      end
    end

    register :simple_web_server, ::Rack::Handler::SimpleWebServer
  end
end
