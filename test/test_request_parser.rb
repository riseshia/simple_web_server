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
    assert_equal("GET", request.method)
    assert_equal({
                   "Accept" => "text/*",
                   "Host" => "www.example.com"
                 }, request.headers)
    assert_equal("/get.text", request.path)
    assert_equal("query_string", request.query_string)
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
    assert_equal("POST", request.method)
    assert_equal({
                   "Accept" => "text/*",
                   "Host" => "www.example.com",
                   "Content-type" => "text/plain",
                   "Content-length" => "17"
                 }, request.headers)
    assert_equal("/books", request.path)
    assert_nil request.query_string
    assert_equal("title=some_title", request.body)
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
    assert_equal("Which message requires unsupported HTTP version.", e.message)
  end
end
