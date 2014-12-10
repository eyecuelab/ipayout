require 'securerandom'
require 'ipayout'
require 'pry'
require 'spec_helper'

describe Ipayout do
  subject { Ipayout.new }
  before do
    @client = Ipayout.new
    Ipayout.configuration.endpoint = 'https://testewallet.com/eWalletWS/ws_JsonAdapter.aspx'
    Ipayout.configuration.merchant_guid = 'a4739056-7db6-40f3-9618-f2bcccbf70cc'
    Ipayout.configuration.merchant_password = '9xXLvA66hi'
  end

  it 'should have a version' do
    expect(Ipayout::VERSION).to_not be_nil
  end

  describe '#configure' do
    before do
      Ipayout.configure do |config|
        config.endpoint = 'https://testewallet.com/xxxxxx/ws_JsonAdapter.aspx'
        config.merchant_password = 'elS0l'
        config.merchant_guid = '1212112121212121'
      end
    end

    it 'returns the values set by configuration' do
      config = Ipayout.configuration
      expect(config.endpoint).to eq('https://testewallet.com/xxxxxx/ws_JsonAdapter.aspx')
      expect(config.merchant_password).to eq('elS0l')
      expect(config.merchant_guid).to eq('1212112121212121')
    end
  end

  describe '.reset' do
    before :each do
      Ipayout.configure do |config|
        config.endpoint = 'https://testewallet.com/000000000/ws_JsonAdapter.aspx'
      end
    end

    it 'resets the configuration' do
      Ipayout.reset
      config = Ipayout.configuration
      expect(config.endpoint).to be_nil
    end
  end

  describe 'requests' do
    context 'Use registered account for other services (same email)' do
      let(:user_email) { 'register-test' + rand.to_s[2..6] + '@eyecuelab.com' }
      it 'should register a new user' do
        base_params = {}
        base_params[:endpoint] = Ipayout.configuration.endpoint
        base_params[:MerchantGUID] = Ipayout.configuration.merchant_guid
        base_params[:MerchantPassword] =
          Ipayout.configuration.merchant_password

        options_hash = base_params
        options_hash[:fn] = 'eWallet_RegisterUser'
        options_hash[:UserName] = user_email
        options_hash[:FirstName] = 'Glen'
        options_hash[:LastName] = 'Danzig'
        options_hash[:CompanyName] = 'EyeCue Lab'
        options_hash[:Address1] =  '3934 NE M L King Blvd'
        options_hash[:Address2] = ''
        options_hash[:City] = 'Portland'
        options_hash[:State] = 'OR'
        options_hash[:ZipCode] = '97212'
        options_hash[:Country2xFormat] = 'US'
        options_hash[:PhoneNumber] = '5038415250'
        options_hash[:CellPhoneNumber] = ''
        options_hash[:EmailAddress] = user_email
        options_hash[:SSN] = ''
        options_hash[:CompanyTaxID] = ''
        options_hash[:GovernmentID] = ''
        options_hash[:MilitaryID] = ''
        options_hash[:PassportNumber] = ''
        options_hash[:DriversLicense] = ''
        options_hash[:DateOfBirth] = '10/17/1980'
        options_hash[:WebsitePassword] = ''
        options_hash[:DefaultCurrency] = 'USD'
        options_hash[:SkipAutoSVCOrder] = ''
        options_hash[:PreferredLanguage] = ''
        options_hash[:IsBusinessUser] = ''
        options_hash[:BusinessUserName] = ''

        response = @client.ewallet_request(options_hash)
        expect(response['m_Text']).to eq('OK')

        # We are packing all the tests in to this one 'it' because they
        # depend on the information that results from registering
        # a user.

        #test account status
        options_hash = base_params
        options_hash[:fn] = 'eWallet_GetUserAccountStatus'
        options_hash[:UserName] = user_email
        response = @client.ewallet_request(options_hash)
        expect(response['m_Text']).to eq('OK')
        expect(response).to include('AccStatus')

        #test disbursement
        transaction_hex = SecureRandom.hex(16)
        transaction_hex.insert(-27, '-')
        transaction_hex.insert(-22, '-')
        transaction_hex.insert(-17, '-')
        transaction_hex.insert(-12, '-')

        options_hash = base_params
        options_hash[:fn]               = 'eWallet_Load'
        options_hash[:PartnerBatchID]   = DateTime.now.to_s
        options_hash[:PoolID]           = ''
        options_hash[:arrAccounts]      = [{ UserName: user_email,
                                             Amount:   1.00,
                                             Comments: 'Test Test Test',
                                             MerchantReferenceID:
                                             transaction_hex }]
        options_hash[:AllowDuplicates]  = true
        options_hash[:AutoLoad]         = true
        options_hash[:CurrencyCode]     = 'USD'
        response = @client.ewallet_request(options_hash)
        expect(response['m_Text']).to eq('OK')
        expect(response).to include('TransactionRefID')
        options_hash = base_params
        options_hash[:fn] = 'eWallet_GetCurrencyBalance'
        options_hash[:UserName] = user_email
        options_hash[:CurrencyCode] = 'USD'
        response = @client.ewallet_request(options_hash)
        expect(response['m_Text']).to eq('OK')
        expect(response).to include('CurrencyCode')
      end
    end
  end
end
