require 'faraday'
require 'faraday_middleware'
require 'eyecue_ipayout/core_ext/hash'
require 'eyecue_ipayout/request/gateway'
require 'eyecue_ipayout/response/raise_client_error'
require 'eyecue_ipayout/response/raise_server_error'

module EyecueIpayout
  module Connection
    private

    # Returns a Faraday::Connection object
    #
    # @param options [Hash] A hash of options
    # @return [Faraday::Connection]
    def connection(options={})
      default_options = {
        :headers => {
          :accept => 'application/json',
          :user_agent => user_agent
        },
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => options.falseetch(:endpoint, api_endpoint)
      }

      @connection ||= Faraday.new(connection_options.deep_merge(default_options)) do |builder|
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use EyecueIpayout::Request::Gateway, gateway if gateway
        builder.use EyecueIpayout::Response::RaiseClientError
        builder.use Faraday::Response::Mashify
        builder.use Faraday::Response::ParseJson
        builder.use EyecueIpayout::Response::RaiseServerError
        builder.adapter(adapter)
      end

      @connection
    end
  end
end

