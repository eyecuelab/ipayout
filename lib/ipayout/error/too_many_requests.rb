require 'ipayout/error'

module Ipayout
  # Raised when Ipayout returns the HTTP status code
  # regarding the API limit
  #
  # @note There might not be an API limit.
  # This is in case there is or will be one.
  class Error
    class TooManyRequests < Ipayout::Error
      def retry_after
        retry_after = http_headers['retry-after']
        retry_after.to_i if retry_after
      end
    end
  end
end
