class Admin::VideosController < ApplicationController
  before_filter :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(params[:video])

    if @video.save
      flash[:success] = "#{@video.title} added."
      redirect_to new_admin_video_path
    else
      render :new
    end
  end
end
