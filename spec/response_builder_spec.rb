# frozen_string_literal: true

describe SimpleWebServer::ResponseBuilder do
  it "processes response message without body" do
    res = SimpleWebServer::Response.new
    res.http_version = "HTTP/1.1"
    res.status_code = 204
    res.headers = {
      "Content-Type" => "text/html",
      "Content-Length" => "0",
      "Location" => "/books"
    }
    actual_msg = SimpleWebServer::ResponseBuilder.build(res)
    expected_msg = crlf(<<~END_OF_MESSAGE, true)
      HTTP/1.1 204 No Content
      Content-Type: text/html
      Content-Length: 0
      Location: /books

    END_OF_MESSAGE

    expect(actual_msg.read).to eq(expected_msg)
  end

  it "processes response message with body" do
    res = SimpleWebServer::Response.new
    res.http_version = "HTTP/1.1"
    res.status_code = 200
    res.headers = {
      "Content-Type" => "text/html",
      "Content-Length" => "19"
    }
    res.body = StringIO.new("<html>Hello!</html>")
    actual_msg = SimpleWebServer::ResponseBuilder.build(res)
    expected_msg = crlf(<<~END_OF_MESSAGE)
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 19

      <html>Hello!</html>
    END_OF_MESSAGE

    expect(actual_msg.read).to eq(expected_msg)
  end

  it "processes response message with multiple values header" do
    res = SimpleWebServer::Response.new
    res.http_version = "HTTP/1.1"
    res.status_code = 200
    res.headers = {
      "Content-Type" => "text/html",
      "Content-Length" => "13",
      "Set-Cookie" => ["a=1", "b=2; HttpOnly"]
    }
    res.body = StringIO.new("<html></html>")
    actual_msg = SimpleWebServer::ResponseBuilder.build(res)
    expected_msg = crlf(<<~END_OF_MESSAGE)
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 13
      Set-Cookie: a=1
      Set-Cookie: b=2; HttpOnly

      <html></html>
    END_OF_MESSAGE

    expect(actual_msg.read).to eq(expected_msg)
  end
end
