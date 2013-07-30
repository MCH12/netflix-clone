class ReviewsController < ApplicationController
  before_filter :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = Review.new(params[:review].merge!(video: @video, user: current_user))

    if @review.save
      redirect_to @video
    else
      @reviews = @video.reviews
      render 'videos/show'
    end
  end
end
