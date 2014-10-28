require 'bundler/setup'
Bundler.setup

require 'eyecue_ipayout'

RSpec.configure do |config|
  puts config
  IPAYOUT_API_ENDPOINT = 'https://testewallet.com/eWalletWS/ws_JsonAdapter.aspx'
  IPAYOUT_MERCHANT_GUID = 'a4739056-7db6-40f3-9618-f2bcccbf70cc'
  IPAYOUT_MERCHANT_PASSWORD = '9xXLvA66hi'
end
