require 'spec_helper'

describe InvitationsController do
  describe 'GET new' do
    it_behaves_like 'require_user' do
      let(:action) { get :new }
    end

    before do
      set_current_user
      get :new
    end

    it 'sets @invitation' do
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end
  end

  describe 'POST create' do
    it_behaves_like 'require_user' do
      let(:action) { post :create }
    end

    context 'with valid input' do
      after { ActionMailer::Base.deliveries.clear }
      before do
        set_current_user
        post :create, invitation: { recipient_name: 'Recipient Name',
                        recipient_email: 'recipient@example.com',
                        message: 'Message' }
      end

      it 'creates invitation' do
        expect(Invitation.count).to eq(1)
      end

      it 'sends email to recipient' do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['recipient@example.com'])
      end

      it 'redirects to invitation page' do
        expect(response).to redirect_to invite_path
      end
      it 'sets flash[:success]' do
        expect(flash[:sucess]).to have_content
      end
    end

    context 'with invalid input' do
      before do
        ActionMailer::Base.deliveries.clear
        set_current_user
        post :create, invitation: { }
      end

      it 'sets @invitation' do
        expect(assigns(:invitation)).to be_present
      end

      it 'does not create invitation' do
        expect(Invitation.count).to eq(0)
      end

      it 'does not send email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'renders new' do
        expect(response).to render_template :new
      end
    end
  end
end
