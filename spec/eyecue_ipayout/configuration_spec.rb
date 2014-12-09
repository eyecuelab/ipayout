# spec/ipayout/configuration_spec.rb

require 'spec_helper'
require 'ipayout/configuration'
module Ipayout
  describe Configuration do
    describe '#endpoint=' do
      it 'can set value' do
        config = Configuration.new
        config.endpoint = 'https://testewallet.com/eWalletWS/ws_JsonAdapter.aspx'
        expect(config.endpoint).to eq('https://testewallet.com/eWalletWS/ws_JsonAdapter.aspx')
      end
    end
  end
end
