require 'bundler/setup'
Bundler.setup

require 'ipayout'

RSpec.configure do |_config|

  Ipayout.configure do |config|
    config.endpoint = Ipayout.configuration.endpoint
    config.merchant_guid = Ipayout.configuration.merchant_guid
    config.merchant_password = Ipayout.configuration.merchant_password
  end
end
