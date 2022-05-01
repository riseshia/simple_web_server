# frozen_string_literal: true

module SimpleWebServer
  # Request class
  class Request
    attr_reader :method, :headers

    def initialize(
      method:,
      headers:
    )
      @method = method
      @headers = headers
    end
  end
end
