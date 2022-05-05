# frozen_string_literal: true

module SimpleWebServer
  # RequestParser is for parsing request message
  class RequestParser
    # @param raw_request [IO]
    # @return [SimpleWebServer::Request]
    def self.parse(raw_request)
      start_line, *rest_lines = raw_request.each_line.map(&:strip)

      start_line_info = parse_start_line(start_line)
      info = parse_header_and_body(rest_lines)

      Request.new(
        method: start_line_info[:method],
        headers: info[:headers],
        path: start_line_info[:path],
        query_string: start_line_info[:query_string],
        body: info[:body]
      )
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

    private_class_method def self.parse_header_and_body(lines)
      headers = lines.take_while { |l| l.size > 0 }
      body_start_lineno = headers.size + 1
      body =
        if lines[body_start_lineno]
          lines[body_start_lineno..].join("\n")
        else
          nil
        end

      { headers: parse_header_lines(headers), body: body }
    end

    private_class_method def self.parse_header_lines(header_lines)
      header_lines.each_with_object({}) do |line, obj|
        tokens = line.split(":")
        if tokens.size < 2
          raise SimpleWebServer::ParseError, "Some header has invalid format."
        end

        key = tokens.shift
        value = tokens.join(":").strip
        obj[key] = value
      end
    end
  end
end
