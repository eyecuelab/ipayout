require 'cgi'
require 'eyecue_ipayout/api'
require 'eyecue_ipayout/param_map'

module EyecueIpayout
  # Wrapper for the EyecueIpayout REST API

  class Client < API
    # Require client method modules after initializing the Client class in
    # order to avoid a superclass mismatch error, allowing those modules to be
    # Client-namespaced.
    require 'eyecue_ipayout/client/ewallet'

    alias :api_endpoint :endpoint

    include EyecueIpayout::Client::Ewallet
  end
end

