# frozen_string_literal: true

module SimpleWebServer
  # ResponseBuilder is for building response message
  class ResponseBuilder
    REASON_PHRASE = {
      100 => "Continue",
      101 => "Switching Protocols",

      200 => "OK",
      201 => "Created",
      202 => "Accepted",
      203 => "Non-Authoritative Information",
      204 => "No Content",
      205 => "Reset Content",
      206 => "Partial Content",

      300 => "Multiple Choices",
      301 => "Moved Permanently",
      302 => "Found",
      303 => "See Other",
      304 => "Not Modified",
      305 => "Use Proxy",
      307 => "Temporary Redirect",

      400 => "Bad Request",
      401 => "Unauthorized",
      402 => "Payment Required",
      403 => "Fobidden",
      404 => "Not Found",
      405 => "Method Not Allowed",
      406 => "Not Acceptable",
      407 => "Proxy Authentication Required",
      408 => "Request Timeout",
      409 => "Conflict",
      410 => "Gone",
      411 => "Length Required",
      412 => "Precondition Failed",
      413 => "Request Entity Too Large",
      414 => "Request URI Too Long",
      415 => "Unsupported Media Type",
      416 => "Requested Range Not Satisfiable",
      417 => "Expectation Failed",

      500 => "Internal Server Error",
      501 => "Not Implemented",
      502 => "Bad Gateway",
      503 => "Service Unavailable",
      504 => "Gateway Timeout",
      505 => "HTTP Version Not Supported"
    }.freeze

    # @param response [SimpleWebServer::Response]
    # @return [String]
    def self.build(response)
      rows = []
      rows << "#{response.http_version} #{response.status_code} #{REASON_PHRASE[response.status_code]}"

      response.headers.each do |k, v|
        if v.is_a? Array
          v.each do |pv|
            rows << "#{k}: #{pv}"
          end
        else
          rows << "#{k}: #{v}"
        end
      end

      rows << ""

      if response.body
        rows << response.body.read
      end

      rows.join(SimpleWebServer::Utils::CRLF)
    end
  end
end
