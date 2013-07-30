require 'spec_helper'

describe RelationshipsController do
  describe 'GET index' do
    it_behaves_like 'require_user' do
      let(:action) { get :index }
    end

    it 'sets @relationships to the current_user' do
      set_current_user
      leader = Fabricate(:user)
      relationship = Relationship.create!(follower: current_user, leader: leader)
      get :index

      expect(assigns(:relationships)).to eq([relationship])
    end
  end

  describe 'DELETE destroy' do
    it_behaves_like 'require_user' do
      let(:action) { delete :destroy, id: 1 }
    end

    let(:leader) { Fabricate(:user) }
    before do
      set_current_user
      request.env['HTTP_REFERER'] = '/request_path'
      relationship = Relationship.create!(leader: leader, follower: current_user)
      delete :destroy, id: relationship.id
    end

    it 'deletes the relationship if current_user is the follower' do
      expect(Relationship.count).to eq(0)
    end

    it 'does not delete the relationship if current_user is not the follower' do
      relationship = Relationship.create!(leader: current_user, follower: Fabricate(:user))
      delete :destroy, id: relationship.id

      expect(Relationship.count).to eq(1)
    end

    it 'redirects back' do
      expect(response).to redirect_to '/request_path'
    end
  end

  describe 'POST create' do
    it_behaves_like 'require_user' do
      let(:action) { post :create, leader_id: 1 }
    end

    let(:leader) { Fabricate(:user) }
    before do
      set_current_user
      post :create, leader_id: leader
    end

    it 'creates a relationship where current_user follows leader' do
      expect(Relationship.last.leader).to eq(leader)
      expect(Relationship.last.follower).to eq(current_user)
    end

    it 'sets flash[:notice]' do
      expect(flash[:success]).to_not be_blank
    end

    it 'does not create relationship if current_user already follows user' do
      expect(Relationship.count).to eq(1)
      post :create, leader_id: leader
      expect(Relationship.count).to eq(1)
    end

    it 'redirects to user_path of leader' do
      expect(response).to redirect_to leader
    end
  end
end
