require 'securerandom'
require 'ipayout'
require 'spec_helper'
require 'date'

describe Ipayout do
  let(:client) { Ipayout.new }

  before do
    Ipayout.configuration.endpoint =
      'https://testewallet.com/eWalletWS/ws_JsonAdapter.aspx'
    Ipayout.configuration.merchant_guid =
      'a4739056-7db6-40f3-9618-f2bcccbf70cc'
    Ipayout.configuration.merchant_password = '9xXLvA66hi'
  end

  it 'should have a version' do
    expect(Ipayout::VERSION).to_not be_nil
  end

  describe '#configure' do
    before do
      Ipayout.configure do |config|
        config.endpoint =
          'https://testewallet.com/xxxxxx/ws_JsonAdapter.aspx'
        config.merchant_password = 'elS0l'
        config.merchant_guid = '1212112121212121'
      end
    end

    it 'returns the values set by configuration' do
      config = Ipayout.configuration
      expect(config.endpoint)
        .to eq('https://testewallet.com/xxxxxx/ws_JsonAdapter.aspx')
      expect(config.merchant_password).to eq('elS0l')
      expect(config.merchant_guid).to eq('1212112121212121')
    end
  end

  describe '.reset' do
    before :each do
      Ipayout.configure do |config|
        config.endpoint =
          'https://testewallet.com/000000000/ws_JsonAdapter.aspx'
      end
    end

    it 'resets the configuration' do
      Ipayout.reset
      config = Ipayout.configuration
      expect(config.endpoint).to be_nil
    end
  end

  describe '#ewallet_request' do
    let(:base_params) do
      {
        endpoint: Ipayout.configuration.endpoint,
        MerchantGUID: Ipayout.configuration.merchant_guid,
        MerchantPassword: Ipayout.configuration.merchant_password
      }
    end

    before(:all) do
      @user_email = 'register-test' + rand.to_s[2..6] + '@eyecuelab.com'
    end

    context 'register user' do
      before do
        @response = client.ewallet_request(options_hash)
      end

      let(:options_hash) do
        base_params.merge(
                            fn: 'eWallet_RegisterUser',
                            UserName: @user_email,
                            FirstName: 'Glen',
                            LastName: 'Danzig',
                            CompanyName: 'EyeCue Lab',
                            Address1:  '3934 NE M L King Blvd',
                            Address2: '',
                            City: 'Portland',
                            State: 'OR',
                            ZipCode: '97212',
                            Country2xFormat: 'US',
                            PhoneNumber: '5038415250',
                            CellPhoneNumber: '',
                            EmailAddress: @user_email,
                            SSN: '',
                            CompanyTaxID: '',
                            GovernmentID: '',
                            MilitaryID: '',
                            PassportNumber: '',
                            DriversLicense: '',
                            DateOfBirth: '10/17/1980',
                            WebsitePassword: '',
                            DefaultCurrency: 'USD',
                            SkipAutoSVCOrder: '',
                            PreferredLanguage: '',
                            IsBusinessUser: '',
                            BusinessUserName: ''
                          )
      end

      it 'should register a new user' do
        expect(@response['m_Code']).to eq(0)
      end
    end

    context 'account status' do
      before do
        @response = client.ewallet_request(options_hash)
      end

      let(:options_hash) do
        base_params.merge(
                            fn: 'eWallet_GetUserAccountStatus',
                            UserName: @user_email
                          )
      end

      it 'fetches account status' do
        expect(@response['m_Code']).to eq(0)
        expect(@response).to include('AccStatus')
      end
    end

    context 'disbursement' do
      let(:options_hash) do
        base_params.merge(
          fn:              'eWallet_Load',
          PartnerBatchID:  DateTime.now.to_s,
          PoolID:          '',
          arrAccounts:     [account1],
          AllowDuplicates: true,
          AutoLoad:        true,
          CurrencyCode:    'USD'
        )
      end

      context 'when ewallet exists' do
        before do
          @response = client.ewallet_request(options_hash)
        end

        let(:account1) do
          { UserName:            @user_email,
            Amount:              53.00,
            Comments:            'Test Test Test',
            MerchantReferenceID: '142014W' }
        end

        it 'successfully disburses funds' do
          expect(@response['m_Code']).to eq(0)
          expect(@response).to include('TransactionRefID')
        end
      end

      context 'ewallet does not exist' do
        let(:account1) do
          { UserName:            'fakeusername',
            Amount:              53.00,
            Comments:            'Test Test Test',
            MerchantReferenceID: '142014W' }
        end

        it 'wont successfully disburses funds' do
          expect { client.ewallet_request(options_hash) }
            .to raise_error(
              Ipayout::Error::EwalletNotFound,
              'Customer with user name fakeusername is not found')
        end

        it 'will have airbrake error info' do
          expect { client.ewallet_request(options_hash) }
              .to raise_error do |err|
                    req_body = err.to_airbrake[:params][:request_body]
                    expect(req_body['arrAccounts'][0]['UserName'])
                        .to eq(account1[:UserName])
                  end
        end
      end
    end
  end
end
