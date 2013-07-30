require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    context 'with no email' do
      before { post :create, email: '' }
      it 'redirects to forgot_password_path' do
        expect(response).to redirect_to forgot_password_path
      end

      it 'shows error message' do
        expect(flash[:error]).to_not be_blank
      end
    end

    context 'with existing email' do
      let(:user) { Fabricate(:user) }
      before { post :create, email: user.email }

      it 'redirects to confirmation page' do
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends email to user's email" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end
    end

    context 'with non-existing email' do
      before { post :create, email: 'invalid email' }
      it 'redirects to forgot_password_path' do
        expect(response).to redirect_to forgot_password_path
      end

      it 'displays error message' do
        expect(flash[:error]).to_not be_blank
      end
    end
  end
end
