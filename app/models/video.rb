class Video < ActiveRecord::Base
  has_and_belongs_to_many :categories, order: :category_id
  has_many :queue_items
  has_many :reviews, order: "created_at DESC"

  validates_presence_of :title, :description, :video_url

  # TODO Make this work with add video and figure out how to make the tests pass
  # validates_presence_of :categories

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(term)
    return [] if term.blank?
    where("title LIKE ?", "%#{term}%")
  end

  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end
end
