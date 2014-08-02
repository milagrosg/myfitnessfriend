class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    
    if user.confirmed == true
      if user
        session[:user_id] = user.id
        if params[:remember_me]
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end
        redirect_to root_url, :notice => "Logged in!"
      else
        flash.now.alert = "Invalid email or password"
        render "new"
      end
    else
      flash.now.alert = "Please check your email and confirm your account."
      render "new"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
