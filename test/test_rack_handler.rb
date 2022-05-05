# frozen_string_literal: true

require_relative "helper"

class TestRackHandler < Minitest::Test
  def setup
    @app = Rack::Lint.new(EchoMiddleware.new)
  end

  def test_rack_lint
    req = SimpleWebServer::Request.new(
      method: "GET",
      headers: {
        "Accept" => "text/*",
        "Host" => "www.example.com",
        "Content-Length" => "10"
      },
      path: "/books",
      query_string: "q=Title",
      body: "some body"
    )
    res = @app.call(req.to_env)
    body_str = res[2].instance_variable_get(:@body)[0]
    res_body = JSON.parse(body_str).reject { |k, _v| k.start_with?("rack.") }

    expected_status = 200
    expected_headers = {
      "content-type" => "text/json",
      "content-length" => "455"
    }
    expected_body = {
      "REQUEST_METHOD" => "GET",
      "SERVER_NAME" => SimpleWebServer::SERVER_NAME,
      "QUERY_STRING" => "q=Title",
      "SCRIPT_NAME" => "",
      "PATH_INFO" => "/books",
      "test.postdata" => "some body",
      "HTTP_ACCEPT" => "text/*",
      "HTTP_HOST" => "www.example.com",
      "CONTENT_LENGTH" => "10"
    }

    assert_equal(expected_status, res[0])
    assert_equal(expected_headers, res[1])
    assert_equal(expected_body, res_body)
  end
end
