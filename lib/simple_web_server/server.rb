# frozen_string_literal: true

require "socket"

module SimpleWebServer
  # TCP Server
  # XXX: Support connection by socket
  class Server
    def initialize(rack_handler)
      @shutdown_server = false
      @rack_handler = rack_handler
    end

    def start_server
      server = TCPServer.new("127.0.0.1", 3000)
      # Signal.trap(:INT) { @shutdown_server = true }

      loop do
        socket = server.accept
        res = @rack_handler.process(socket)
        socket.write(res)
        socket.close

        break if @shutdown_server
      end
    end
  end
end
