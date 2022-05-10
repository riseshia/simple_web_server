# frozen_string_literal: true

describe "Rack::Handler::SimpleWebServer" do
  before do
    @body = []
    app = proc {
      [200, { "Content-Type" => "text/html", "Content-Length" => @body.map(&:size).sum.to_s }, @body]
    }
    Rack::Handler::SimpleWebServer.app = app
  end

  it "returns response message with no body" do
    @body = []

    doc = req_io(<<~END_OF_MESSAGE)
      GET /get.text?query_string HTTP/1.1
      Accept: text/*
      Host: www.example.com

    END_OF_MESSAGE

    res_msg = Rack::Handler::SimpleWebServer.process(doc)

    expected = req_io(<<~END_OF_MESSAGE)
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 0

    END_OF_MESSAGE

    expect(res_msg).to eq(expected.read)
  end

  it "returns response message with enumerable body" do
    @body = ["hogehoge"]

    doc = req_io(<<~END_OF_MESSAGE)
      GET /get.text?query_string HTTP/1.1
      Accept: text/*
      Host: www.example.com

    END_OF_MESSAGE

    res_msg = Rack::Handler::SimpleWebServer.process(doc)

    expected = req_io(<<~END_OF_MESSAGE.strip)
      HTTP/1.1 200 OK
      Content-Type: text/html
      Content-Length: 8

      hogehoge
    END_OF_MESSAGE

    expect(res_msg).to eq(expected.read)
  end
end
