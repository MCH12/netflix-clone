class PasswordResetsController < ApplicationController
  def show
    @user = User.where(token: params[:id]).first

    if @user
      @token = @user.token
    else
      redirect_to expired_token_path unless @user
    end
  end

  def create
    @user = User.where(token: params[:token]).first

    if @user
      @user.password = params[:password]
      if @user.save
        @user.generate_token
        flash[:success] = 'Your password has been changed.'
        redirect_to login_path
      else
        flash[:error] = 'Invalid Password'
        @token = @user.token
        render :show
      end
    else
      redirect_to expired_token_path
    end
  end
end
