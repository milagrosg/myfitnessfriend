class ConfirmationEmailController < ApplicationController
  def new
  end

  def edit
    @user = User.find_by_confirmation_token!(params[:id])
    if @user
      @user.update_attribute(:confirmed, true)
      redirect_to login_path, :notice => "Account has been confirmed."
    else
      redirect_to signup_path
    end  
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :password_hash, :password_salt)
  end
end

