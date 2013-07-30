require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe 'GET new_with_invitation' do
    let(:invitation) { Fabricate(:invitation, inviter_id: Fabricate(:user).id) }
    before { get :new_with_invitation, token: invitation.token }

    it 'renders :new template' do
      expect(response).to render_template :new
    end

    it 'sets @user with recipient email' do
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it 'sets @invitation_token' do
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it 'redirects to expired_token_path for invalid token' do
      get :new_with_invitation, token: ''
      expect(response).to redirect_to expired_invitation_path
    end
  end

  describe 'POST create' do
    context 'successful user signup' do
      before do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'redirects to login' do
        expect(response).to redirect_to login_path
      end

      it 'sets success notice' do
        expect(flash[:success]).to_not be_blank
      end
    end

    context 'failed user signup' do
      before do
        result = double(:sign_up_result, successful?: false,
                                         error_message: 'Error Message',
                                         invitation_token: 'x')
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), invitation_token: 'x'
      end

      it 'sets @invitation_token' do
        expect(assigns(:invitation_token)).to eq('x')
      end

      it 'sets flash[:error]' do
        expect(flash[:error]).to be_present
      end

      it 'renders :new' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET show' do
    it_behaves_like 'require_user' do
      let(:action) { get :show, id: Fabricate(:user) }
    end

    it 'sets @user' do
      set_current_user
      user = Fabricate(:user)
      get :show, id: user
      expect(assigns(:user)).to eq(user)
    end
  end
end
