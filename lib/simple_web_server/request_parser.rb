# frozen_string_literal: true

module SimpleWebServer
  # RequestParser is for parsing request message
  class RequestParser
    module Header
      CONTENT_LENGTH = "content-length"
    end

    # @param raw_request [IO]
    # @return [SimpleWebServer::Request]
    def self.parse(raw_request)
      start_line = raw_request.gets
      start_line_info = parse_start_line(start_line)

      req = Request.new(
        http_version: start_line_info[:http_version],
        method: start_line_info[:method],
        path: start_line_info[:path],
        query_string: start_line_info[:query_string]
      )

      header_rows = raw_request.take_while { |l| l.strip.size > 0 }
      headers = parse_header_lines(header_rows)
      req.headers = headers

      content_length = req.headers[Header::CONTENT_LENGTH].to_i

      if content_length > 0
        req.body = StringIO.new(raw_request.read(content_length))
      end

      req
    end

    private_class_method def self.parse_start_line(line)
      tokens = line.split
      if tokens.size != 3
        raise SimpleWebServer::ParseError, "Which message has invalid start line."
      end

      method, path_with_query_string, http_version = tokens
      path = path_with_query_string.split("?").first
      query_string_start_idx = path.size + 1
      query_string =
        if query_string_start_idx < path_with_query_string.size
          path_with_query_string[query_string_start_idx..]
        end

      if http_version != "HTTP/1.1"
        raise SimpleWebServer::ParseError, "Which message requires unsupported HTTP version."
      end

      {
        method: method,
        path: path,
        query_string: query_string,
        http_version: http_version
      }
    end

    private_class_method def self.parse_header_lines(header_lines)
      header_lines.each_with_object({}) do |line, obj|
        tokens = line.split(":")
        if tokens.size < 2
          raise SimpleWebServer::ParseError, "Some header has invalid format."
        end

        # Normalize header key
        key = tokens.shift.downcase
        value = tokens.join(":").strip
        obj[key] = value
      end
    end
  end
end
