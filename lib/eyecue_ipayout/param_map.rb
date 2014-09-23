require 'extlib'

params_by_service = {}
responses_by_service = {}
base_service_responses = ["m_Code", "m_Text"]

params_by_service["register_user"] = ["MerchantGUID","MerchantPassword","UserName","FirstName","LastName","CompanyName","Address1","Address2","City","State","ZipCode","Country2xFormat","PhoneNumber","CellPhoneNumber","EmailAddress","SSN","CompanyTaxID","GovernmentID","MilitaryID","PassportNumber","DriversLicense","DateOfBirth","WebsitePassword","DefaultCurrency","SkipAutoSVCOrder","PreferredLanguage","IsBusinessUser","BusinessUserName"]

responses_by_service["register_user"] = ['TransactionRefID']

def map_param_list(param_list)
  param_map = {}
  param_list.each do |param|
    #puts '"' + v + '":"' + v.snake_case + '",'
    param_map[param.snake_case] = param
    return param_map
  end
end
