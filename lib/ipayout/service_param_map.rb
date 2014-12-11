require 'ipayout/version'
require 'ipayout/service'
require 'ipayout/service_param'

module Ipayout
  class ServiceParamMap
    attr_accessor :ewallet_services
    # Initializes new ServiceParamMap object
    #
    # @param [String] name
    # @param [Hash] expected_type
    # @param [Boolean] required
    # @return [Ipayout::ServiceParam]
    # @instantiate Ipayout::ServiceParam.new("FirstName", "String", true)

    def initialize
      @ewallet_services = {}
      build_service_map
    end

    def get_service_by_name(service_name)
      @ewallet_services[service_name] if @ewallet_services.key? service_name
    end

    #  eWallet_RegisterUser Service Map
    def build_register_service
      service = Ipayout::Service.new('register_user')
      service.add_param('fn', 'String', true)
      service.add_param('endpoint', 'String', true)
      service.add_param('MerchantGUID', 'String', true)
      service.add_param('MerchantPassword', 'String', true)
      service.add_param('UserName', 'String', true)
      service.add_param('FirstName', 'String', true)
      service.add_param('FirstName', 'String', true)
      service.add_param('LastName', 'String', true)
      service.add_param('CompanyName', 'String', true)
      service.add_param('Address1', 'String', true)
      service.add_param('Address2', 'String', true)
      service.add_param('City', 'String', true)
      service.add_param('State', 'String', true)
      service.add_param('ZipCode', 'String', true)
      service.add_param('Country2xFormat', 'String', true)
      service.add_param('PhoneNumber', 'String', true)
      service.add_param('CellPhoneNumber', 'String', false)
      service.add_param('EmailAddress', 'String', true)
      service.add_param('SSN', 'String', false)
      service.add_param('CompanyTaxID', 'String', false)
      service.add_param('GovernmentID', 'String', false)
      service.add_param('MilitaryID', 'String', false)
      service.add_param('PassportNumber', 'String', false)
      service.add_param('DriversLicense', 'String', false)
      service.add_param('DateOfBirth', 'String', true)
      service.add_param('WebsitePassword', 'String', true)
      service.add_param('DefaultCurrency', 'String', true)
      service.add_param('SkipAutoSVCOrder', 'String', false)
      service.add_param('PreferredLanguage', 'String', false)
      service.add_param('IsBusinessUser', 'String', false)
      service.add_param('BusinessUserName', 'String', false)

      service.response_parameters = %w(m_Code m_Text
                                                LogTransactionID
                                                TransactionRefID
                                                ACHTransactionID
                                                ProcessorTransactionRefNumbe
                                                CustomerFeeAmount
                                                CurrencyCode)
      service
    end

    #  eWallet_GetCustomerDetails Service Map
    def build_details_service
      service = Ipayout::Service.new('get_customer_details')
      service.add_param('fn', 'String', true)
      service.add_param('endpoint', 'String', true)
      service.add_param('MerchantGUID', 'String', true)
      service.add_param('MerchantPassword', 'String', true)
      service.add_param('UserName', 'String', true)

      res_params = %w(UserName CustomerGuid IsActivated Email FirstName LastName
                      CompanyName Phone CellPhoneNumber
                      eWalletID Address1 Address2 State City ZipCode
                      Country DateOfBirth IsSuspended
                      IsInfoVerified IsClosed CreatedDate IsAgreedToFees
                      IsBusiness IsInvalidEmail PreferredLanguage
                      SVCShippingAddress)
      service.response_parameters = res_params
      service
    end

    #  eWallet_GetUserAccountStatus Service
    def build_account_service
      service = Ipayout::Service.new('get_user_account_status')
      service.add_param('fn', 'String', true)
      service.add_param('endpoint', 'String', true)
      service.add_param('MerchantGUID', 'String', true)
      service.add_param('MerchantPassword','String', true)
      service.add_param('UserName', 'String', true)
      service.response_parameters = %w(m_Code m_Text)
      service
    end

    #  eWallet_RequestUserAutoLogin Service
    def build_login_service
      service = Ipayout::Service.new('request_user_auto_login')
      service.add_param('fn', 'String', true)
      service.add_param('endpoint', 'String', true)
      service.add_param('MerchantGUID', 'String', true)
      service.add_param('MerchantPassword', 'String', true)
      service.add_param('UserName', 'String', true)
      service.response_parameters = %w(m_Code m_Text m_ProcessorTransactionRefNumber)
      service
    end

    #  eWallet_Load Service
    def build_load_service
      service = Ipayout::Service.new('ewallet_load')
      service.add_param('fn', 'String', true)
      service.add_param('endpoint', 'String', true)
      service.add_param('MerchantGUID', 'String', true)
      service.add_param('MerchantPassword', 'String', true)
      service.add_param('PartnerBatchID', 'String', true)
      service.add_param('PoolID', 'String', true)
      service.add_param('MerchantPassword', 'String', true)
      service.add_param('arrAccounts', 'String', true)
      service.add_param('AllowDuplicates', 'String', true)
      service.add_param('AutoLoad', 'Boolean', true)
      service.add_param('CurrencyCode', 'Boolean', true)
      service.response_parameters = %w(m_Code m_Text)
      service
    end

    def build_service_map
      # register_service = build_register_service
      # details_service = build_details_service
      # account_service = build_account_service
      # login_service = build_login_service
      # load_service = build_load_service
      @ewallet_services = {
        register_user:            build_register_service,
        get_customer_details:     build_details_service,
        get_user_account_status:  build_account_service,
        request_user_auto_login:  build_login_service,
        ewallet_load:             build_load_service
      }
    end
  end
end
