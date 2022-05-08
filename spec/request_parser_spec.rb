# frozen_string_literal: true

describe SimpleWebServer::RequestParser do
  it "parses get" do
    doc = <<~END_OF_MESSAGE
      GET /get.text?query_string HTTP/1.1
      Accept: text/*
      Host: www.example.com
    END_OF_MESSAGE
    request = req(doc)

    expect(request.method).to eq("GET")
    expect(request.headers).to eq({
                                    "Accept" => "text/*",
                                    "Host" => "www.example.com"
                                  })
    expect(request.path).to eq("/get.text")
    expect(request.query_string).to eq("query_string")
    expect(request.body).to be_nil
  end

  it "parses post with body" do
    doc = <<~END_OF_MESSAGE
      POST /books HTTP/1.1
      Accept: text/*
      Host: www.example.com
      Content-Type: text/plain
      Content-Length: 16

      title=some_title
    END_OF_MESSAGE
    request = req(doc)

    expect(request.method).to eq("POST")
    expect(request.headers).to eq({
                                    "Accept" => "text/*",
                                    "Host" => "www.example.com",
                                    "Content-Type" => "text/plain",
                                    "Content-Length" => "16"
                                  })
    expect(request.path).to eq("/books")
    expect(request.query_string).to be_nil
    expect(request.body.read).to eq("title=some_title")
  end

  it "raises error with http 1.0 request" do
    doc = <<~END_OF_MESSAGE
      GET /get.text HTTP/1.0
      Accept: text/*
      Host: www.example.com
    END_OF_MESSAGE
    expect { req(doc) }.to raise_error(SimpleWebServer::ParseError, "Which message requires unsupported HTTP version.")
  end
end
