# frozen_string_literal: true

require_relative "simple_web_server/version"
require_relative "simple_web_server/utils"
require_relative "simple_web_server/request"
require_relative "simple_web_server/request_parser"
require_relative "simple_web_server/response"
require_relative "simple_web_server/response_builder"

module SimpleWebServer
  class ParseError < StandardError; end
end
