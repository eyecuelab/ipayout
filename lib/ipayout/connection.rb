require 'faraday'
require 'faraday_middleware'
require 'ipayout/core_ext/hash'
require 'ipayout/response/raise_client_error'
require 'ipayout/response/raise_server_error'
require 'ipayout/config'

module Ipayout
  module Connection
    private

    # Returns a Faraday::Connection object
    # rubocop:disable MethodComplexity
    def connection
      default_options = {
        headers: {
          accept: 'application/json',
          user_agent: user_agent
        },
        ssl: { verify: false }

      }

      faraday_options = connection_options.deep_merge(default_options)
      faraday_options['url'] = Ipayout.configuration.endpoint
      faraday_options['proxy'] = Ipayout.configuration.proxy

      Faraday.new(url: faraday_options['url'], proxy: faraday_options['proxy']) do |faraday|
        faraday.request :url_encoded
        #faraday.response :logger
        faraday.adapter Faraday.default_adapter
        faraday.use Ipayout::Response::RaiseClientError
        faraday.use Ipayout::Response::RaiseServerError
        faraday.use Faraday::Response::Mashify
        faraday.use Faraday::Response::ParseJson
      end
    end
  end
end
