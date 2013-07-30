class SessionsController < ApplicationController
  def new
    redirect_back if current_user
  end

  def create
    user = User.where(email: params[:email]).first

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = 'Signed In'
      redirect_back
    else
      flash[:error] = 'Invalid email or password.'
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed Out'
  end
end
