  # Ipayout

This gem serves as a wrapper for the iPayout eWallet Web Service.

iPayout hosts some fairly recent documentation for their API.

https://www.i-payout.com/API/default.aspx


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ipayout', :git => 'https://github.com/eyecuelab/ipayout.git'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install ipayout

```

## Configuration

There are a few important constants that you will need to set
as environment variables.  When you do that, make sure you set
them based on the Rails environment that is
running (eg. production, development...)

    #this example is set to use their testing sandbox
    Ipayout.endpoint = 'https://testewallet.com/eWalletWS/ws_JsonAdapter.aspx'
    Ipayout.merchant_guid = <YOUR MERCHANT GUID>
    Ipayout.merchant_password = <YOUR MERCHANT PASSWORD>

## Usage

Here's how you can use this gem to interact with the iPayout eWallet API.

This gem targets the main service that accepts and returns JSON. iPayout provides endpoints that accept and return different formats (like XML).  However, the JSON endpoint represents is their most recent service an

### Initialization
In your Rails 4.1 project, create an initializer called ipayout.rb in config/inititalizers.  You can pass your project's credentials through Ipayout.configuration like so:

```ruby
Ipayout.configuration do |config|
  config.endpoint =
    Rails.application.secrets.ipayout_api_endpoint
  config.merchant_guid =
    Rails.application.secrets.ipayout_merchant_guid
  config.merchant_password =
    Rails.application.secrets.ipayout_merchant_password
end

```

### the Client
The Client is the higher-level object that speaks to the iPayout eWallet API. It also provides the Service objects.

```ruby
  require 'ipayout'

  client = Ipayout.new
  options_hash = {}
  options_hash[:fn] = 'eWallet_GetCustomerDetails'
  options_hash[:endpoint] = Ipayout.configuration.endpoint
  options_hash[:MerchantGUID] = Ipayout.configuration.merchant_guid
  options_hash[:MerchantPassword] = Ipayout.configuration.merchant_password
  options_hash[:UserName] = 'Glen Danzig'

  service_name = "get_customer_details"
  service = client.get_service(service_name)
```

### the Service
The Service object is instantiated to handle specific calls to the iPayout API.  We can tell the service object what endpoint to hit, and which parameters to send with that request.  What's more, the service object can also return all the parameters that a service will accept.

```ruby
  require 'ipayout'

  client = Ipayout.new
  service_name = "eWallet_GetCustomerDetails"
  service = client.get_service(service_name)

  #what params do I need to send for this API call?
  expected_params = service.request_param_list

  # populate that param list as you see fit.
  # in this example, we're using a hypothetical method called
  # populate_service_values
  populated_parameters = populate_service_values(expected_params)

  # All the values are assigned.  Send that out to the eWallet API
  # Hold on....What service is this calling?
  # Remember, the service that you want to call is specified using the
  # "fn" parameter.
  response = client.ewallet_request(populated_parameters)
```
Here's the guts of that JSON request (to the test server, in this example):

{'fn':'eWallet_GetCustomerDetails','endpoint':'https://testewallet.com/eWalletWS/ws_JsonAdapter.aspx','MerchantGUID':'a4739056-x3985-xxxx-xxxx-xxxxxxxxx','MerchantPassword':'xXxxXxxXx','UserName':'SomeUserName'}

### Which services can I hit?

#### Request automatic login token
params = {fn: 'eWallet_RequestUserAutoLogin', .....}
client.ewallet_request(params)

#### Register a new user with iPayout
params = {fn: 'eWallet_RegisterUser', .....}
client.ewallet_request(params)

#### Get an iPayout user's account details
params = {fn: 'eWallet_GetCustomerDetails', .....}
client.ewallet_request(params)

#### See if their account is active
params = {fn: 'eWallet_GetUserAccountStatus', .....}
client.ewallet_request(params)

#### Distribute money to an iPayout user
params = {fn: "eWallet_Load", .....}
client.ewallet_request(params)

## The Response

When you call an iPayout service through the client, you can expect a hash in return, regardless of success or exception.

Responses differ per service request.  There are, however, a couple of consistant parameters that you can reliably reference.

  m_code : That's the numerical response status for your request.  200 means it processed just fine.  500 means there was a server error.

  m_text: This is the human readable message that reports your request's result status.




