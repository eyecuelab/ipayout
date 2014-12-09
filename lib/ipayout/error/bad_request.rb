require 'ipayout/error'

module Ipayout
  # Raised when Ipayout returns the HTTP status code 400
  class Error
    class BadRequest < Ipayout::Error
    end
  end
end
