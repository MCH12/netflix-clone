require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    context 'with valid token' do
      let(:user) { Fabricate(:user) }
      before { get :show, id: user.token }

      it 'renders password_resets#show' do
        expect(response).to render_template(:show)
      end

      it 'sets @token' do
        expect(assigns(:token)).to eq(user.token)
      end
    end

    context 'with invalid token' do
      before { get :show, id: '' }
      it 'redirects to invalid token path if invalid' do
        expect(response).to redirect_to expired_token_path
      end
    end
  end

  describe 'POST create' do
    context 'with valid token' do
      let(:user) { Fabricate(:user, token: '123') }
      before { post :create, token: user.token, password: 'new_password' }
      it "updates user's password" do
        expect(user.reload.authenticate('new_password')).to be_true
      end

      it "regenerates user's token" do
        expect(user.reload.token).not_to eq('123')
      end

      it "sets flash success" do
        expect(flash[:success]).to be_present
      end

      it "redirects to login" do
        expect(response).to redirect_to login_path
      end

      context 'with invalid password' do
        let(:bad_password_user) { Fabricate(:user) }
        before { post :create, token: user.token, password: '' } 
        it 'renders #show' do
          expect(response).to render_template(:show)
        end

        it 'sets @token' do
          expect(assigns(:token)).to eq(user.token)
        end
      end
    end

    context 'with invalid token' do
      it 'redirects to expired_token_path' do
        post :create, token: '', password: ''
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
