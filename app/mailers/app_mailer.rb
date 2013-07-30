class AppMailer < ActionMailer::Base
  def notify_on_register(user)
    @user = user
    mail from: 'admin@myflix.com',
         to: user.email,
         subject: "Welcome to MyFlix"
  end

  def send_password_reset(user)
    @user = user
    mail from: 'admin@myflix.com',
         to: user.email,
         subject: 'Password Reset'
  end

  def send_invitation(invitation)
    @invitation = invitation
    mail from: 'admin@myflix.com',
         to: invitation.recipient_email,
         subject: 'Invitation to MyFlix'
  end
end
