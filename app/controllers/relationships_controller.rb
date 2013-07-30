class RelationshipsController < ApplicationController
  before_filter :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def create
    @leader = User.find(params[:leader_id])
    @relationship = Relationship.new(leader: @leader, follower: current_user)

    flash[:success] = "Following #{@leader.full_name}" if @relationship.save

    redirect_to @leader
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    if @relationship.follower == current_user
      @relationship.destroy
      flash[:notice] = "No longer following #{@relationship.leader.full_name}"
    end

    store_location && redirect_back
  end
end
