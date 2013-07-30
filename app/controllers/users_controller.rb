class UsersController < ApplicationController
  before_filter :require_user, only: [:show]
  def new
    @user = User.new
  end

  def new_with_invitation
    invitation = Invitation.where(token: params[:token]).first

    if invitation
      @invitation_token = invitation.token
      @user = User.new(email: invitation.recipient_email)
      render :new
    else
      redirect_to expired_invitation_path
    end
  end

  def create
    @user = User.new(params[:user])
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])

    if result.successful?
      flash[:success] = 'Account Created'
      redirect_to login_path
    else
      @invitation_token = params[:invitation_token]
      flash[:error] = result.error_message if result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
