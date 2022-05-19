# frozen_string_literal: true

require "socket"
require "uri"

module SimpleWebServer
  # TCP Server
  # XXX: Support connection by socket
  class Server
    def initialize(rack_handler, config)
      @shutdown_server = false
      @rack_handler = rack_handler
      @config = config
    end

    def start_server
      uri = URI.parse(@config.bind)
      server = TCPServer.new(uri.host, uri.port)

      loop do
        socket = server.accept
        res = @rack_handler.process(socket)
        socket.write(res.read)
        socket.close

        break if @shutdown_server
      end
    end
  end
end
