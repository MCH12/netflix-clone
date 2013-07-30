require 'spec_helper'

describe VideosController do
  before { set_current_user }
  let(:video) { Fabricate(:video, title: 'video 1') }
  describe "GET show" do
    before { get :show, id: video }

    it "sets @video" do
      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews" do
      reviews = Fabricate(:review, video: video)
      expect(assigns(:reviews)).to match_array([reviews])
    end

    it "sets @review" do
      expect(assigns(:review)).to be_instance_of(Review)
    end

    it_behaves_like 'require_user' do
      let(:action) { get :show, id: video }
    end
  end


  describe "POST search" do
    it "sets @results" do
      post :search, term: '1'
      expect(assigns(:results)).to eq([video])
    end
    
    it 'redirects to root' do
      session[:user_id] = nil
      post :search, term: '1'
      expect(response).to redirect_to root_path
    end
    
    #error: no route matches
    #it_behaves_like 'require_user' do
      #let(:action) { post :seach, term: '1' }
    #end
  end
end
