module Api
  module V1
    class BaseController < ApplicationController

      def base(status, message, data)
        ActiveSupport::JSON.encode({status: status, message: message, data: data})
      end

      private
      def restrict_access
        authenticate_or_request_with_http_token do |token, options|
          @user = User.where(access_token: token).first
          if @user
            true
          else
            message = I18n.t 'unauthorized_access'
            render :json => base(401, message, nil)
          end
        end
      end       
    end
  end
end
