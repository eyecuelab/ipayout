require 'ipayout/error'

module Ipayout
  # Raised when Ipayout returns the HTTP status code 500
  class Error
    class InternalServerError < Ipayout::Error
    end
  end
end
