require 'ipayout/error'

module Ipayout
  # Raised when Ipayout returns the HTTP status code 401
  class Error
    class Unauthorized < Ipayout::Error
    end
  end
end
