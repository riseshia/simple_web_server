# frozen_string_literal: true

module SimpleWebServer
  # Response class
  class Response
    attr_accessor :http_version, :status_code, :headers, :body

    # @param status_code [Integer]
    # @param headers [Hash<String, String | Array<String>>]
    # @param body [#each | String]
    # @return [SimpleWebServer::Response]
    def from_call(status_code, headers, body)
      @status_code = status_code
      @headers = headers.transform_keys do |key|
        if key == Rack::RACK_HIJACK
          raise NotImplementedError
        else
          key
        end
      end

      @body = StringIO.new.binmode
      if body.respond_to?(:to_path)
        @body = ::File.open(body.to_path, "rb")
      elsif body.respond_to?(:each)
        body.each do |part|
          @body << part
        end
      else
        # streaming body or hijacked io
        raise NotImplementedError
      end
      @body.rewind
    ensure
      body.close if body.respond_to?(:close)
    end
  end
end
