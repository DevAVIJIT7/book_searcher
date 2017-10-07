module Api
  module V1
    class SessionsController < BaseController
      before_filter :restrict_access, except: [:login]
      respond_to :json

      def login
        email = request.headers["email"]
        password = request.headers["password"]

        login_response = User.user_login(email, password)

        status  = login_response[:status]
        message = login_response[:message]
        data    = login_response[:data]
        
        render :json => base(status, message, data)
      end

      def logout
        @user.update(access_token: nil,access_token_expire_time:nil)
        message = I18n.t 'sessions.successful.signed_out'
        render :json => base(200, message, nil)
      end
    end
  end
end