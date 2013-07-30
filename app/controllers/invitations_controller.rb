class InvitationsController < ApplicationController
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(params[:invitation].merge!(inviter_id: current_user.id))

    if @invitation.save
      AppMailer.delay.send_invitation(@invitation)
      flash[:success] = "#{@invitation.recipient_name} invited!"
      redirect_to invite_path
    else
      render :new
    end
  end

  def expired
  end
end
