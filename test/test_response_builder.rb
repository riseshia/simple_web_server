# frozen_string_literal: true

require_relative "helper"

class TestResponseBuilder < Minitest::Test
  def test_with_body_response
    expected_message = [
      "HTTP/1.1 200 OK",
      "Content-Type: text/html",
      "Content-Length: 19",
      "",
      "<html>Hello</html>"
    ].join(SimpleWebServer::Utils::CRLF)

    response = SimpleWebServer::Response.new(
      http_version: "HTTP/1.1",
      status_code: 200,
      headers: { "Content-Type" => "text/html", "Content-Length" => 19 },
      body: "<html>Hello</html>"
    )
    actual_message = SimpleWebServer::ResponseBuilder.build(response)
    assert_equal expected_message, actual_message
  end

  def test_without_body_response
    expected_message = [
      "HTTP/1.1 204 No Content",
      ""
    ].join(SimpleWebServer::Utils::CRLF)

    response = SimpleWebServer::Response.new(
      http_version: "HTTP/1.1",
      status_code: 204,
      headers: {},
      body: nil
    )
    actual_message = SimpleWebServer::ResponseBuilder.build(response)
    assert_equal expected_message, actual_message
  end
end
