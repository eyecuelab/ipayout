module EyecueIpayout
  class Client
    
    module Ewallet

      def register_user(options={})
        get("1/status_updates", options)
      end

    end
  end
end



