module Ipayout
  class Configuration
    attr_accessor :endpoint
    attr_accessor :proxy
    attr_accessor :merchant_guid
    attr_accessor :merchant_password

    def initialize
      @endpoint = nil
      @proxy = nil
      @merchant_guid = nil
      @merchant_password = nil
    end
  end
end
