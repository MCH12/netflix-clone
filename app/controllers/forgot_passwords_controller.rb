class ForgotPasswordsController < ApplicationController
  def create
    @user = User.where(email: params[:email]).first

    if @user
      AppMailer.delay.send_password_reset(@user)
      redirect_to forgot_password_confirmation_path
    else
      redirect_to forgot_password_path
      flash[:error] = 'Invalid Email'
    end
  end
end
