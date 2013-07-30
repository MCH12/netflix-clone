require 'spec_helper'

describe ReviewsController do
  before { set_current_user }
  let(:video) { Fabricate(:video) }

  context "with valid input" do
    before { post :create, review: Fabricate.attributes_for(:review), video_id: video}

    it "creates a review" do
      expect(Review.count).to eq(1)
    end
    it "creates a review that belongs_to video" do
      expect(Review.first.video).to eq(video)
    end
    it "creates a review that belongs_to user" do
      expect(Review.first.user).to eq(current_user)
    end

    it "redirects to video#show" do
      expect(response).to redirect_to video
    end
  end

  context "with invalid input" do
    before { post :create, review: {}, video_id: video}
    it "does not create review" do
      expect(Review.count).to eq(0)
    end

    it "renders video#show" do
      expect(response).to render_template "videos/show"
    end

    it "sets @video" do
      expect(assigns[:video]).to eq(video)
    end

    it "sets @review" do
      expect(assigns(:review)).to be_present
    end

    it "sets @reviews" do
      Fabricate(:review, video: video) 
      expect(assigns(:reviews)).to match_array(Review.all)
    end
  end

  it_behaves_like 'require_user' do
    let(:action) { post :create, review: {}, video_id: video }
  end
end
