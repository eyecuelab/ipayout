require 'json'

module Ipayout
  # Custom error class for rescuing from all eWallet errors
  class Error < StandardError
    attr_reader :http_headers, :raw_body

    # Initializes new Error object
    #
    # @param [String] message
    # @param [Hash] http_headers
    # @param [String] raw_body
    # @return [Ipayout::Error]
    def initialize(message, http_headers = {}, raw_body = '')
      @http_headers = http_headers
      @raw_body = raw_body
      super message
    end

    # Support Airbrake custom attrs.
    # When using Airbrake.io the request body will
    # be sent along with the error to assist in debugging.
    # https://github.com/airbrake/airbrake-ruby#custom-exception-attributes
    #
    # @return [Hash]
    def to_airbrake
      { params: { request_body: JSON.parse(raw_body) } }
    end

    # @return [Time]
    def ratelimit_reset
      reset = http_headers['x-ratelimit-reset']
      Time.at(reset.to_i) if reset
    end

    # @return [Integer]
    def ratelimit_limit
      limit = http_headers['x-ratelimit-limit']
      limit.to_i if limit
    end

    # @return [Integer]
    def ratelimit_remaining
      remaining = http_headers['x-ratelimit-remaining']
      remaining.to_i if remaining
    end

    # @return [Integer]
    def retry_after
      [(ratelimit_reset - Time.now).ceil, 0].max if ratelimit_reset
    end
  end
end
