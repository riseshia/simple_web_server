# frozen_string_literal: true

module SimpleWebServer
  # Request class
  class Request
    attr_reader :method, :headers, :body

    # @param method [String]
    # @param headers [Hash<String, String>]
    # @param body [String]
    def initialize(
      method:,
      headers:,
      body:
    )
      @method = method
      @headers = headers
      @body = body
    end
  end
end
