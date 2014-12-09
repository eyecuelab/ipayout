require 'ipayout/error'

module Ipayout
  # Raised when Ipayout returns the HTTP status code 403
  class Error
    class Forbidden < Ipayout::Error
    end
  end
end
