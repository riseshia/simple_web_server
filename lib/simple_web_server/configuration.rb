# frozen_string_literal: true

module SimpleWebServer
  # Configuration class
  class Configuration
    OPTIONS = %i[
      bind
      logger
    ].freeze

    OPTIONS.each do |key|
      attr_accessor key

      define_method(key) do
        @options[key]
      end

      define_method("#{key}=") do |val|
        @options[key] = val
      end
    end

    def initialize(**passed_options)
      @options = default_options.merge(passed_options.transform_keys(&:to_sym))
    end

    def default_options
      {
        bind: "tcp://127.0.0.1:3000",
        logger: $stdout
      }
    end
  end
end
