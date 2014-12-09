require 'ipayout/config'
require 'ipayout/configuration'
require 'ipayout/connection'
require 'ipayout/service_param_map'

module Ipayout
  class API
    include Connection

    attr_reader :service_param_map
    attr_accessor(*Config::VALID_OPTIONS_KEYS)
    # Creates a new API
    def initialize(options = {})
      options = Ipayout.options.merge(options)
      @service_param_map = Ipayout::ServiceParamMap.new
      Config::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end
  end
end
