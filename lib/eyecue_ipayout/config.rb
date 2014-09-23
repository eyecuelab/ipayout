require 'eyecue_ipayout/version'

module EyecueIpayout
  # Defines constants and methods related to configuration
  module Config

    MERCHANT_NAME = "SunStand"
    API_MERCHANT_ID = "a4739056-7db6-40f3-9618-f2bcccbf70cc"

    PRODUCTION_BASE_URL = "https://sunstand.globalewallet.com"
    PRODUCTION_WEBSERVICE_URL = "https://www.i-payout.net/eWalletWS/ws_Adapter.aspx"

    SANDBOX_BASE_URL = "https://sunstand.testewallet.com/"
    SANDBOX_WEBSERVICE_URL = "https://www.testewallet.com/eWalletWS/ws_Adapter.aspx"
    
      # The access token if none is set
    DEFAULT_ACCESS_TOKEN = nil

    # The HTTP connection adapter that will be used to connect if none is set
    DEFAULT_ADAPTER = :net_http

    # The Faraday connection options if none are set
    DEFAULT_CONNECTION_OPTIONS = {}

    # The endpoint that will be used to connect if none is set
    DEFAULT_ENDPOINT = "http://localhost:3000/"

    # The gateway server if none is set
    DEFAULT_GATEWAY = nil

    # The proxy server if none is set
    DEFAULT_PROXY = nil

    # The value sent in the 'User-Agent' header if none is set
    DEFAULT_USER_AGENT = "EyecueIpayout Ruby Gem #{EyecueIpayout::VERSION}"


    # An array of valid keys in the options hash when configuring a {EyecueIpayout::API}
    VALID_OPTIONS_KEYS = [
      :merchant_name,
      :api_merchant_id,
      :production_webservice_url,
      :production_base_url,
      :sandbox_webservice_url,
      :sandbox_base_url,
      :gateway,
      :endpoint,
      :user_agent,
      :adapter,
      :connection_options,
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
      self.merchant_name              = MERCHANT_NAME
      self.api_merchant_id            = API_MERCHANT_ID
      self.production_webservice_url  = PRODUCTION_WEBSERVICE_URL
      self.production_base_url        = PRODUCTION_BASE_URL
      self.sandbox_webservice_url     = SANDBOX_WEBSERVICE_URL
      self.sandbox_base_url           = SANDBOX_BASE_URL
      self.adapter            = DEFAULT_ADAPTER
      self.connection_options = DEFAULT_CONNECTION_OPTIONS
      self.endpoint           = DEFAULT_ENDPOINT
      self.gateway            = DEFAULT_GATEWAY
      self.user_agent         = DEFAULT_USER_AGENT
      self
    end
  end
end
