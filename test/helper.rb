# frozen_string_literal: true

require "minitest/autorun"
require "minitest/focus"

require "simple_web_server"

Dir["#{Dir.pwd}/test/support/*.rb"].sort.each do |path|
  require path
end
