require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }
  it { should validate_numericality_of(:position) }

  describe ".rating" do
    let!(:user) { Fabricate(:user) }
    let!(:video) { Fabricate(:video) }

    it "should return rating of the review if user has review" do
      review = Fabricate(:review, user: user, video: video)
      queue_item =  Fabricate(:queue_item, user: user, video: video) 

      expect(queue_item.rating).to eq(review.rating)
    end

    it "should return nil if user has no review" do
      queue_item =  Fabricate(:queue_item, user: user, video: video) 

      expect(queue_item.rating).to be_nil
    end
  end

  describe ".rating=" do
    let!(:user) { Fabricate(:user) }
    let!(:video) { Fabricate(:video) }
    let!(:review) { Fabricate(:review, rating: 2, user: user, video: video) }
    let!(:queue_item) { Fabricate(:queue_item, user: user, video: video) }

    it 'changes the rating of review if review exists' do
      queue_item.rating = 3

      expect(review.reload.rating).to eq(3)
    end

    it 'deletes review if rating is set to nothing' do
      expect(Review.count).to eq(1)
      queue_item.rating = nil

      expect(Review.count).to eq(0)
    end

    it 'creates review and sets rating if review doesn\'t exist' do
      review.destroy
      queue_item.rating = 3

      expect(queue_item.rating).to eq(3)
    end
  end
end
