require 'ipayout/error'

module Ipayout
  # Raised when Ipayout returns the HTTP status code 503
  class Error
    class ServiceUnavailable < Ipayout::Error
    end
  end
end
