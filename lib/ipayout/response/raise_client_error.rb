require 'faraday'
require 'ipayout/error/bad_request'
require 'ipayout/error/too_many_requests'
require 'ipayout/error/forbidden'
require 'ipayout/error/not_acceptable'
require 'ipayout/error/not_found'
require 'ipayout/error/unauthorized'

module Ipayout
  module Response
    class RaiseClientError < Faraday::Response::Middleware
      def on_complete(env)
        case env[:status].to_i
        when 400
          fail Ipayout::Error::BadRequest.new(error_message(env),
                                              env[:response_headers])
        when 401
          fail Ipayout::Error::Unauthorized.new(error_message(env),
                                                env[:response_headers])
        when 403
          if env[:body]['error'] == 'over_limit'
            fail Ipayout::Error::TooManyRequests.new(error_message(env),
                                                     env[:response_headers])
          else
            fail Ipayout::Error::Forbidden.new(error_message(env),
                                               env[:response_headers])
          end
        when 404
          fail Ipayout::Error::NotFound.new(error_message(env),
                                            env[:response_headers])
        when 406
          fail Ipayout::Error::NotAcceptable.new(error_message(env),
                                                 env[:response_headers])
        else
          fail Ipayout::Error::NotAcceptable.new(error_message('Unknown Error'),
                                                 env[:response_headers])
        end
      end

      private

      def error_message(env)
        "#{env[:method].to_s.upcase} #{env[:url]}: \
          #{env[:status]}#{error_body(env[:body])}"
      end

      # rubocop:disable MethodLength
      def error_body(body)
        if body.nil?
          nil
        elsif body['error']
          ": #{body['error']}"
        elsif body['errors']
          first = Array(body['errors']).first
          if first.is_a? Hash
            ": #{first['message'].chomp}"
          else
            ": #{first.chomp}"
          end
        end
      end
    end
  end
end
