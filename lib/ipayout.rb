require 'ipayout/client'
require 'ipayout/config'
require 'ipayout/configuration'
require 'ipayout/service'
require 'ipayout/service_param'

module Ipayout
  extend Config
  class << self
    attr_accessor :configuration

    # Alias for Ipayout::Client.new
    #
    # @return [Ipayout::Client]
    def new
      Ipayout::Client.new
    end

    # Delegate to Ipayout::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private = false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
