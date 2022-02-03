class SessionsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :create

    def create
        @auth=request.env["omniauth.auth"]
        user=Moviegoer.find_by_provider_and_uid(@auth["provider"],@auth["uid"]) ||
        Moviegoer.create_with_omniauth(@auth)
        Rails.logger.debug("@auth : #{@auth[:info]}")
        Rails.logger.debug("@name : #{@auth[:info][:name]}")
        session[:user_id] = user.id
        session[:name] = @auth[:info][:name]
        session[:image] = @auth[:info][:image]
        redirect_to movies_path 
    end
    
    def destroy
        session.delete(:user_id)
        flash[:notice] = 'Logged out successfully.'
        redirect_to movies_path
    end

    def failure 
        flash[:warning] = params[:message]
        redirect_to movies_path
    end


end
