# frozen_string_literal: true

require "logger"
require "stringio"

module SimpleWebServer
  # Request class
  class Request
    attr_accessor :http_version, :method, :headers, :path, :query_string, :body

    # @param http_version [String]
    # @param method [String]
    # @param headers [Hash<String, String>]
    # @param path [String]
    # @param query_string [String]
    # @param body [String]
    def initialize( # rubocop:disable Metrics/ParameterLists
      http_version: nil,
      method: nil,
      headers: nil,
      path: nil,
      query_string: nil,
      body: nil
    )
      @http_version = http_version
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
      }.merge(http_headers)
    end

    CONTENT_HEADERS = %w[CONTENT_TYPE CONTENT_LENGTH].freeze
    private def http_headers
      @headers.transform_keys do |key|
        upcased_key = key.gsub("-", "_").upcase

        if CONTENT_HEADERS.include?(upcased_key)
          upcased_key
        else
          "HTTP_#{upcased_key}"
        end
      end
    end
  end
end
