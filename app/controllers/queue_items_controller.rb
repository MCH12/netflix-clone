class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    @video = Video.find(params[:video_id])
    @queue_item = QueueItem.new(video: @video, user: current_user, position: new_position)

    @queue_item.save ? flash[:success] = "#{@video.title} added to queue" : flash[:error] = 'Video already in queue'

    redirect_to @video
  end

  def destroy
    store_location
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    normalize_queue_positions
    flash[:notice] =  "#{queue_item.video.title} removed from queue."
    redirect_back
  end

  def update_queue
    unless params[:queue_items]
      return redirect_to queue_path, notice: "Nothing in Queue."
    end

    begin
      update_queue_items
      normalize_queue_positions
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid Position."
    end
    redirect_to queue_path
  end

  private

  def new_position
    current_user.queue_items.count + 1
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item|
        item = QueueItem.find(queue_item["id"])
        item.update_attributes!(position: queue_item["position"], rating: queue_item["rating"]) if item.user == current_user
      end
    end
  end

  def normalize_queue_positions
    current_user.queue_items.each_with_index do |queue_item,index|
      queue_item.update_attributes(position: index + 1)
    end
  end
end
