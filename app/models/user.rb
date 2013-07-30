class User < ActiveRecord::Base
  include Tokenable

  has_secure_password

  has_many :reviews, order: "created_at DESC"
  has_many :queue_items, order: :position
  has_many :following_relationships, class_name: 'Relationship', foreign_key: :follower_id
  has_many :payments

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  def video_queued?(video)
    queue_items.map(&:video).include?(video)
  end

  def queue_id(video)
    queue_items.where(video_id: video).map(&:id).first
  end

  def following?(user)
    following_relationships.map(&:leader_id).include?(user.id)
  end

  def follow(user)
    following_relationships.create(leader: user) if can_follow?(user)
  end

  def can_follow?(user)
    !(self.following?(user) || self == user)
  end

  def relationship_id(user)
    following_relationships.where(leader_id: user).map(&:id).first
  end

  def admin?
    false || self.admin
  end
end
