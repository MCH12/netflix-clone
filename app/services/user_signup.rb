class UserSignup
  attr_reader :error_message
  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      customer = StripeWrapper::Customer.create(
        plan: '999_monthly',
        card: stripe_token,
        email: "#{@user.email}",
        description: "Monthly Myflix charge for #{@user.email}"
      )

      if customer.successful?
        @user.stripe_customer_token = customer.id
        @user.save
        handle_invitation(invitation_token)
        AppMailer.delay.notify_on_register(@user)
        @status = :success
        self
      else
        @status = :failure
        @error_message = customer.error_message
        self
      end
    else
      @status = :failure
      self
    end
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.destroy
    end
  end
end
