require 'spec_helper'

describe QueueItemsController do
  before { set_current_user }
  let!(:queue_item1) { Fabricate(:queue_item, position: 1, user: current_user) }
  let!(:queue_item2) { Fabricate(:queue_item, position: 2, user: current_user) }

  describe "GET index" do
    before { get :index }
    it "sets @queue_items for current user" do
      expect(assigns(:queue_items)).to match_array(QueueItem.all)
    end

    it_behaves_like "require_user" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let(:video) { Fabricate(:video) }
    before { post :create, video_id: video }

    it "creates queue item" do
      expect(QueueItem.count).to eq(3)
    end

    it "sets queue item at the end of the list" do
      expect(current_user.queue_items.last.position).to eq(3)
    end

    it "associates queue item with video" do
      expect(QueueItem.last.video).to eq(video)
    end

    it "associates queue item with user" do
      expect(QueueItem.last.user).to eq(current_user)
    end

    it "sets success notice" do
      expect(flash[:success]).not_to be_blank
    end

    it "sets error if video already in queue" do
      post :create, video_id: video
      expect(flash[:error]).not_to be_blank
    end

    it "redirects to video#show" do
      expect(response).to redirect_to video
    end

    it_behaves_like "require_user" do
      let(:action) { post :create }
    end
  end

  describe "DELETE destroy" do
    before { delete :destroy, id: queue_item1 }
    it "removes video from queue with authenticated user" do
      expect(QueueItem.count).to eq(1)
    end

    it "only removes item if in current_user's queue" do
      session[:user_id] = Fabricate(:user)
      delete :destroy, id: queue_item2
      #still deletes from before block
      expect(QueueItem.count).to eq(1)
    end

    it "fixes missing number position error" do
      expect(QueueItem.first.position).to eq(1)
    end

    it "redirects back" do
      request.env['HTTP_REFERER'] = '/request_path'
      delete :destroy, id: queue_item2
      expect(response).to redirect_to '/request_path'
    end

    it "sets :notice" do
      expect(flash[:notice]).to be_present
    end

    it_behaves_like 'require_user' do
      let(:action) { delete :destroy, id: queue_item1 }
    end
  end

  describe "POST update_queue" do
    context "with valid input" do
      it "reorders queue_items" do
        post :update_queue,
              queue_items: [{id: queue_item1, position: 2},
                            {id: queue_item2, position: 1}]
        expect(current_user.queue_items).to eq([queue_item2, queue_item1])
      end
      
      it "fixes position errors" do
        post :update_queue,
              queue_items: [{id: queue_item1, position: 3},
                            {id: queue_item2, position: 5}]
        expect(current_user.queue_items.map(&:position)).to eq([1,2])
      end

      it "redirects to queue path" do
        post :update_queue,
              queue_items: [{id: queue_item1, position: 2},
                            {id: queue_item2, position: 1}]
        expect(response).to redirect_to queue_path
      end
    end

    context "with invalid input" do
      before do
        post :update_queue, queue_items: [{id: queue_item1, position: 2},
                                          {id: queue_item2, position: "a"}]
      end

      it "sets flash[:error]" do
        expect(flash[:error]).to be_present
      end

      it "does not change queue items" do
        expect(queue_item1.reload.position).to eq(1)
        expect(queue_item2.reload.position).to eq(2)
      end

      it "redirects to queue path" do
        expect(response).to redirect_to queue_path
      end
    end 

    context "with queue_items that are not owned by user" do
      let!(:queue_item1) { Fabricate(:queue_item, position: 1, user: current_user) }
      let!(:queue_item2) { Fabricate(:queue_item, position: 2, user: current_user) }
      before do
        session[:user_id] = Fabricate(:user)
        post :update_queue, queue_items: [{id: queue_item1, position: 2},
                                          {id: queue_item2, position: 1}]
      end
      it "does not update item" do
        expect(queue_item1.reload.position).to eq(1)
        expect(queue_item2.reload.position).to eq(2)
      end
    end

    context "with no queue items" do
      before do
        session[:user_id] = Fabricate(:user).id
        post :update_queue
      end
      it "redirects to queue_path" do
        expect(response).to redirect_to queue_path
      end

      it "sets :notice" do
        expect(flash[:notice]).to be_present
      end
    end

    it_behaves_like "require_user" do
      let(:action) { post :update_queue }
    end
  end
end
