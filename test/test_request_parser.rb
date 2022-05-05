# frozen_string_literal: true

require_relative "helper"

class TestRequestParser < Minitest::Test
  def test_get_parse
    doc = <<~END_OF_MESSAGE
      GET /get.text?query_string HTTP/1.1
      Accept: text/*
      Host: www.example.com
    END_OF_MESSAGE

    request = SimpleWebServer::RequestParser.parse(StringIO.new(doc, "rb"))
    assert_equal request.method, "GET"
    assert_equal request.headers, {
      "Accept" => "text/*",
      "Host" => "www.example.com"
    }
    assert_equal request.path, "/get.text"
    assert_equal request.query_string, "query_string"
    assert_nil request.body
  end

  def test_post_with_body_parse
    doc = <<~END_OF_MESSAGE
      POST /books HTTP/1.1
      Accept: text/*
      Host: www.example.com
      Content-type: text/plain
      Content-length: 17

      title=some_title
    END_OF_MESSAGE

    request = SimpleWebServer::RequestParser.parse(StringIO.new(doc, "rb"))
    assert_equal request.method, "POST"
    assert_equal request.headers, {
      "Accept" => "text/*",
      "Host" => "www.example.com",
      "Content-type" => "text/plain",
      "Content-length" => "17"
    }
    assert_equal request.path, "/books"
    assert_nil request.query_string
    assert_equal request.body, "title=some_title"
  end

  def test_trace_parse
    skip "should I...?"
  end

  def test_http10_return_status505
    doc = <<~END_OF_MESSAGE
      GET /get.text HTTP/1.0
      Accept: text/*
      Host: www.example.com
    END_OF_MESSAGE

    e = assert_raises(SimpleWebServer::ParseError) do
      SimpleWebServer::RequestParser.parse(StringIO.new(doc, "rb"))
    end
    assert_equal e.message, "Which message requires unsupported HTTP version."
  end
end
