class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_confirmation_email 
      redirect_to root_url, :notice => "Check your email for confirmation link."
    else
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :password_hash, :password_salt)
  end
end
