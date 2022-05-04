# frozen_string_literal: true

module SimpleWebServer
  # Request class
  class Request
    attr_reader :method, :headers, :path, :query_string, :body

    # @param method [String]
    # @param headers [Hash<String, String>]
    # @param path [String]
    # @param query_string [String]
    # @param body [String]
    def initialize(
      method:,
      headers:,
      path:,
      query_string:,
      body:
    )
      @method = method
      @headers = headers
      @path = path
      @query_string = query_string
      @body = body
    end

    # Returns Rack environment
    # @return [Hash<String, Object>] the environment
    def to_env
      {
        Rack::REQUEST_METHOD => @method,
        Rack::SERVER_NAME => SimpleWebServer::SERVER_NAME,
        Rack::QUERY_STRING => @query_string || "",
        Rack::RACK_VERSION => Rack::VERSION,
        Rack::RACK_INPUT => StringIO.new(@body || "", "rb"),
        Rack::RACK_ERRORS => $stderr,
        Rack::RACK_MULTITHREAD => false,
        Rack::RACK_MULTIPROCESS => false,
        Rack::RACK_RUNONCE => false,
        Rack::RACK_URL_SCHEME => "http",
        Rack::SCRIPT_NAME => "",
        Rack::PATH_INFO => @path
      }
    end
  end
end
