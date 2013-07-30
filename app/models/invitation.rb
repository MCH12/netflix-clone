class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :inviter, class_name: 'User'

  validates_presence_of :recipient_name, :recipient_email, :message, :inviter_id
  validates_uniqueness_of :recipient_email, message: 'already invited'
  validate :recipient_not_registered

  private

  def recipient_not_registered
    errors.add :recipient_email, 'already registered' if User.find_by_email(recipient_email)
  end
end
