require 'eyecue_ipayout/version'
module EyecueIpayout
  module Config
    IPAYOUT_API_ENDPOINT = 'https://testewallet.com/eWalletWS/ws_JsonAdapter.aspx'
    IPAYOUT_MERCHANT_GUID = 'a4739056-7db6-40f3-9618-f2bcccbf70cc'
    IPAYOUT_MERCHANT_PASSWORD = '9xXLvA66hi'
    # end
    # The access token if none is set
    DEFAULT_ACCESS_TOKEN = nil

    # The HTTP connection adapter that will be used to connect if none is set
    DEFAULT_ADAPTER = :net_http

    # The Faraday connection options if none are set
    DEFAULT_CONNECTION_OPTIONS = {}

    # The endpoint that will be used to connect if none is set
    DEFAULT_ENDPOINT = IPAYOUT_API_ENDPOINT
    DEFAULT_URL = IPAYOUT_API_ENDPOINT

    # The gateway server if none is set
    DEFAULT_GATEWAY = nil

    # The proxy server if none is set
    DEFAULT_PROXY = ''

    # The value sent in the 'User-Agent' header if none is set
    DEFAULT_USER_AGENT = "EyecueIpayout Ruby Gem #{EyecueIpayout::VERSION}"


    # An array of valid keys in the options hash when configuring a {EyecueIpayout::API}
    VALID_OPTIONS_KEYS = [
      :adapter,
      :connection_options,
      :endpoint,
      :gateway,
      :access_token,
      :proxy,
      :user_agent,
      :endpoint,
      :merchant_guid,
      :merchant_password
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end

    # Reset all configuration options to defaults
    def reset
      self.access_token       = DEFAULT_ACCESS_TOKEN
      self.adapter            = DEFAULT_ADAPTER
      self.connection_options = DEFAULT_CONNECTION_OPTIONS
      self.endpoint           = DEFAULT_ENDPOINT
      self.gateway            = DEFAULT_GATEWAY
      self.proxy              = DEFAULT_PROXY
      self.user_agent         = DEFAULT_USER_AGENT
      self.endpoint           = DEFAULT_ENDPOINT
      self.merchant_guid      = IPAYOUT_MERCHANT_GUID
      self.merchant_password  = IPAYOUT_MERCHANT_PASSWORD
      self
    end
  end
end
