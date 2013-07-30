class Category < ActiveRecord::Base
  has_and_belongs_to_many :videos, order: "created_at DESC"
  validates_presence_of :title

  def recent_videos
    videos.first(6)
  end
end
