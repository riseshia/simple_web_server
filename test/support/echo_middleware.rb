# frozen_string_literal: true

require "json"

# EchoMiddleware
#   Rack middleware for test purpose.
# Ref: https://github.com/rack/rack/blob/b0c2656921aec622de72cfe114cb7da0bf408993/test/test_request.rb

class EchoMiddleware
  NOSERIALIZE = [Method, Proc, Rack::Lint::InputWrapper].freeze

  def call(env)
    status = env["QUERY_STRING"] =~ /secret/ ? 403 : 200
    env["test.postdata"] = env["rack.input"].read
    minienv = env.dup
    minienv.delete_if { |_k, v| NOSERIALIZE.any? { |c| v.is_a?(c) } }
    body = minienv.to_json
    size = body.bytesize
    [status, { "content-type" => "text/json", "content-length" => size.to_s }, [body]]
  end
end
