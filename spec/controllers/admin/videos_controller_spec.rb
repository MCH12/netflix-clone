require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'require_admin' do
      let(:action) { get :new }
    end
    before do
      set_admin_user
      get :new
    end

    it 'sets @video to new video' do
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end
  end

  describe 'POST create' do
    it_behaves_like 'require_admin' do
      let(:action) { post :create }
    end

    context 'with valid input' do
      let(:category) { Fabricate(:category) }
      before do
        set_admin_user
        post :create, video: Fabricate.attributes_for(:video, category_ids: [category])
      end

      it 'creates video associated with category' do
        expect(Video.count).to eq(1)
        expect(Video.last.categories).to eq([category])
      end

      it 'redirects to admin/videos#new' do
        expect(response).to redirect_to new_admin_video_path
      end

      it 'sets flash[:success]' do
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid input' do
      before do
        set_admin_user
        post :create, video: {}
      end

      it 'does not create video' do
        expect(Video.count).to eq(0)
      end

      it 'renders new' do
        expect(response).to render_template :new
      end

      it 'sets @video' do
        expect(assigns(:video)).to be_instance_of(Video)
      end
    end
  end
end
