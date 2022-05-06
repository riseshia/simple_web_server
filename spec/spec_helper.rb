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

  def crlf(str, end_with_crlf = false) # rubocop:disable Style/OptionalBooleanParameter
    new_str = str.gsub("\n", SimpleWebServer::Utils::CRLF)

    if end_with_crlf
      if new_str.end_with?(SimpleWebServer::Utils::CRLF)
        new_str
      else
        "#{new_str}#{SimpleWebServer::Utils::CRLF}"
      end
    else
      new_str.strip
    end
  end
end

RSpec.configure do |config|
  config.include Helpers
end
