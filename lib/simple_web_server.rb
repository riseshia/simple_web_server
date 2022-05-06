# frozen_string_literal: true

require "rack"

require_relative "simple_web_server/version"
require_relative "simple_web_server/utils"
require_relative "simple_web_server/request"
require_relative "simple_web_server/request_parser"
require_relative "simple_web_server/response"
require_relative "simple_web_server/response_builder"
require_relative "rack/handlers/simple_web_server"

module SimpleWebServer
  SERVER_NAME = "SimpleWebServer/#{SimpleWebServer::VERSION}"

  class ParseError < StandardError; end
end
