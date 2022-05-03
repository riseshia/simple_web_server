# frozen_string_literal: true

module SimpleWebServer
  # Response class
  class Response
    attr_reader :http_version, :status_code, :method, :headers, :body

    def initialize(
      http_version:,
      status_code:,
      headers:,
      body:
    )
      @http_version = http_version
      @status_code = status_code
      @headers = headers
      @body = body
    end
  end
end
