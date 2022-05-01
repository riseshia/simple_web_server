# frozen_string_literal: true

require_relative "simple_web_server/version"
require_relative "simple_web_server/request"
require_relative "simple_web_server/request_parser"

module SimpleWebServer
  class ParseError < StandardError; end
end
