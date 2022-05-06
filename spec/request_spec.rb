# frozen_string_literal: true

describe SimpleWebServer::Request do
  it "converts itself to rack env" do
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

    expect(req).to validate_with_rack_lint
  end
end
