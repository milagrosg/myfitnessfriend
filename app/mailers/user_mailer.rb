class UserMailer < ActionMailer::Base
  default from: "Maria@MyFitnessFriend.com"

  def password_reset(user)
    @user = user

    mail(to: @user.email, subject: "Password Reset")
  end

  def confirmation_email(user)
    @user = user

    mail(to: @user.email, subject: "Welcome to MyFitnessFriend")
  end
end
