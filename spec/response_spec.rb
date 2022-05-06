# frozen_string_literal: true

describe SimpleWebServer::Response do
  it "returns proper response object" do
    call_res = [
      200,
      {
        "Content-Type" => "text/html",
        "Content-Length" => "19"
      },
      ["<html>", "Hello!", "</html>"]
    ]

    res = SimpleWebServer::Response.new
    res.from_call(*call_res)

    expect(res.status_code).to eq(200)
    expect(res.headers).to eq({
                                "Content-Type" => "text/html",
                                "Content-Length" => "19"
                              })
    expect(res.body.read).to eq("<html>Hello!</html>")
  end
end
