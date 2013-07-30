class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_uniqueness_of :video_id, scope: :user_id
  validates_numericality_of :position

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      if new_rating.blank?
        review.destroy
      else
        review.update_column(:rating, new_rating)
      end
    elsif !new_rating.blank? #don't update review if no rating was set during queue#update
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  private

  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end
