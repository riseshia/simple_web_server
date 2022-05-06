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

        status, headers, body = @app.call(req.to_env)

        res.http_version = "HTTP/1.1"
        res.status_code = status.to_i
        res.headers = headers.transform_keys do |key|
          if key == Rack::RACK_HIJACK
            raise NotImplementedError
          else
            key
          end
        end

        res.body = ""
        if body.respond_to?(:to_path)
          res.body = ::File.open(body.to_path, "rb")
        elsif body.respond_to?(:each)
          body.each do |part|
            res.body += part
          end
        else
          # streaming body or hijacked io
          raise NotImplementedError
        end

        ::SimpleWebServer::ResponseBuilder.build(res)
      ensure
        body.close if body.respond_to?(:close)
      end
    end

    register :simple_web_server, ::Rack::Handler::SimpleWebServer
  end
end
