require 'ipayout/error'

module Ipayout
  # Raised when Ipayout returns the HTTP status code 502
  class Error
    class BadGateway < Ipayout::Error
    end
  end
end
