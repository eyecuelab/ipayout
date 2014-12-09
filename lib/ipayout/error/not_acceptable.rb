require 'ipayout/error'

module Ipayout
  # Raised when Ipayout returns the HTTP status code 406
  class Error
    class NotAcceptable < Ipayout::Error
    end
  end
end
