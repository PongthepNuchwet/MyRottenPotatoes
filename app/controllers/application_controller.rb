class ApplicationController < ActionController::Base
    before_action :set_current_user

    protected 
    def set_current_user
        @current_user ||= Moviegoer.find_by_id(session[:user_id])
        if @current_user
        redirect_to root_path and return unless @current_user
        end
    end
end
