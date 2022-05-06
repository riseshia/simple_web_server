# frozen_string_literal: true

module SimpleWebServer
  # Response class
  class Response
    attr_accessor :http_version, :status_code, :method, :headers, :body

    def initialize(
      http_version: nil,
      status_code: nil,
      headers: nil,
      body: nil
    )
      @http_version = http_version
      @status_code = status_code
      @headers = headers
      @body = body
    end
  end
end
