require 'spec_helper'

describe UserSignup do
  describe '#sign_up' do
    context 'valid personal info and card' do
      before do
        customer = double(:customer, successful?: true, id: '1')
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up('stripe_token', nil)
      end

      it "creates user" do
        expect(User.count).to eq(1)
      end

      context 'with invitation token' do
        let(:inviter) { Fabricate(:user) }
        before do
          customer = double(:customer, successful?: true, id: '1')
          StripeWrapper::Customer.should_receive(:create).and_return(customer)
          invitation = Fabricate(:invitation, inviter_id: inviter.id)
          UserSignup.new(Fabricate.build(:user)).sign_up('stripe_token', invitation.token)
        end

        it 'has new user follow inviter' do
          expect(User.last.following?(inviter)).to be_true
        end

        it 'has inviter follow new user' do
          expect(inviter.following?(User.last)).to be_true
        end

        it 'destroys invitation' do
          expect(Invitation.count).to eq(0)
        end
      end

      context 'email sending' do
        before do
          customer = double(:customer, successful?: true, id: '1')
          StripeWrapper::Customer.should_receive(:create).and_return(customer)
          UserSignup.new(Fabricate.build(:user)).sign_up('stripe_token', nil)
        end
        after { ActionMailer::Base.deliveries.clear }

        let(:user) { user = User.last }

        it 'sends email to correct user' do
          expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
        end

        it 'sends correct content' do
          expect(ActionMailer::Base.deliveries.last.body).to include(user.full_name)
        end
      end
    end

    context 'valid personal info and declined card' do
      before do
        customer = double(:customer, successful?: false, error_message: 'Error Message')
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up('stripe_token', 'y')
      end

      it 'does not create user' do
        expect(User.count).to eq(0)
      end
    end

    context 'with invalid personal info' do
      before do
        ActionMailer::Base.deliveries.clear
        UserSignup.new(User.new()).sign_up('stripe_token', 'y')
      end

      it "doesn't create user" do
        expect(User.count).to eq(0)
      end

      it 'does not send email' do
        expect(ActionMailer::Base.deliveries).to be_blank
      end

      it 'does not charge the card' do
        StripeWrapper::Customer.should_not_receive(:create)
      end
    end
  end
end
