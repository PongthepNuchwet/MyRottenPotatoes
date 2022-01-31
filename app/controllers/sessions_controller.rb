class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :create

    def create
        Rails.logger.debug("create create : ")
        auth=request.env["omniauth.auth"]
        user=Moviegoer.find_by_provider_and_uid(auth["provider"],auth["uid"]) ||
        Moviegoer.create_with_omniauth(auth)
        session[:user_id] = user.id
        redirect_to movies_path
    end
    
    def destroy
        session.delete(:user_id)
        flash[:notice] = 'Logged out successfully.'
        redirect_to movies_path
    end


end
