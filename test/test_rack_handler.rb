# frozen_string_literal: true

require_relative "helper"

class TestRackHandler < Minitest::Test
  def setup
    @app = EchoMiddleware.new
    @handler = Rack::Handler::SimpleWebServer
    @handler.run(@app)
  end

  def test_rack_lint
    app = Rack::Lint.new(@app)
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
    res = app.call(req.to_env)
    body_str = res[2].instance_variable_get(:@body)[0]
    res_body = JSON.parse(body_str).reject { |k, _v| k.start_with?("rack.") }

    expected_status = 200
    expected_headers = {
      "content-type" => "text/json",
      "content-length" => "410"
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

  def test_process
    skip
    doc = <<~END_OF_MESSAGE
      GET /get.text?query_string HTTP/1.1
      Accept: text/*
      Host: www.example.com
    END_OF_MESSAGE

    expected_message = <<~END_OF_MESSAGE.split("\n").join("\r\n")
       200 OK
      content-type: text/json
      content-length: 411

      {"REQUEST_METHOD":"GET","SERVER_NAME":"SimpleWebServer/0.1.0","QUERY_STRING":"query_string","rack.version":[1,3],"rack.input":"#<StringIO:0x0000000104b16bd8>","rack.errors":"#<IO:0x00000001047d0bb8>","rack.multithread":false,"rack.multiprocess":false,"rack.run_once":false,"rack.url_scheme":"http","SCRIPT_NAME":"","PATH_INFO":"/get.text","HTTP_ACCEPT":"text/*","HTTP_HOST":"www.example.com","test.postdata":""}
    END_OF_MESSAGE
    actual_message = @handler.process(doc)

    assert_equal(expected_message, actual_message)
  end
end
