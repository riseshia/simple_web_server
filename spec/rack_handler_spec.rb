# frozen_string_literal: true

describe "Rack::Handler::SimpleWebServer" do
  before do
    @body = []
    app = proc {
      [200, { "Content-Type" => "text/html", "Content-Length" => @body.map(&:size).sum.to_s }, @body]
    }
    Rack::Handler::SimpleWebServer.run(app)
  end

  it "returns response message with no body" do
    @body = []

    doc = <<~END_OF_MESSAGE.split("\n").join(SimpleWebServer::Utils::CRLF)
      GET /get.text?query_string HTTP/1.1
      Accept: text/*
      Host: www.example.com
    END_OF_MESSAGE

    res_msg = Rack::Handler::SimpleWebServer.process(doc)

    expected = <<~END_OF_MESSAGE.split("\n").join(SimpleWebServer::Utils::CRLF)
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 0
    END_OF_MESSAGE
    expected += SimpleWebServer::Utils::CRLF * 2

    expect(res_msg).to eq(expected)
  end

  it "returns response message with enumerable body" do
    @body = ["hogehoge"]

    doc = <<~END_OF_MESSAGE.split("\n").join(SimpleWebServer::Utils::CRLF)
      GET /get.text?query_string HTTP/1.1
      Accept: text/*
      Host: www.example.com
    END_OF_MESSAGE

    res_msg = Rack::Handler::SimpleWebServer.process(doc)

    expected = <<~END_OF_MESSAGE.split("\n").join(SimpleWebServer::Utils::CRLF)
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 8

      hogehoge
    END_OF_MESSAGE

    expect(res_msg).to eq(expected)
  end
end
