# frozen_string_literal: true

require "simple_web_server"

require "rspec/expectations"

RSpec::Matchers.define :validate_with_rack_lint do
  match do |request|
    app = proc {
      [200, { "Content-Type" => "text/html", "Content-Length" => "0" }, []]
    }
    Rack::Lint.new(app).call(request.to_env)
    true
  rescue Rack::Lint::LintError => e
    @message = e.message
    false
  end

  failure_message do
    "expected validate with Rack Lint: #{@message}"
  end
end

module Helpers
  def req(msg)
    SimpleWebServer::RequestParser.parse(
      msg.gsub("\n", SimpleWebServer::Utils::CRLF)
    )
  end
end

RSpec.configure do |config|
  config.include Helpers
end
