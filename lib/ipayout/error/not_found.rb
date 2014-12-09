require 'ipayout/error'

module Ipayout
  # Raised when Ipayout returns the HTTP status code 404
  class Error
    class NotFound < Ipayout::Error
    end
  end
end
