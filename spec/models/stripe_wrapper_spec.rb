require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Customer do
    describe '.create' do
      it 'successfully creates customer', :vcr do
        token = Stripe::Token.create(
          :card => {
            number: '4242424242424242',
            exp_month: 6,
            exp_year: 2016,
            cvc: 314
          }
        ).id

        customer = StripeWrapper::Customer.create(
          card: token,
          plan: '999_monthly',
          email: 'testemail@example.com',
          description: 'Test charge'
        )

        expect(customer).to be_successful
        expect(customer.response.subscription).to be_present
      end

      it 'declines charge on invalid card', :vcr do
        token = Stripe::Token.create(
          :card => {
            number: '4000000000000002',
            exp_month: 6,
            exp_year: 2016,
            cvc: 314
          }
        ).id

        customer = StripeWrapper::Customer.create(
          card: token,
          plan: '999_monthly',
          email: 'testemail@example.com',
          description: 'Test charge'
        )

        expect(customer).to_not be_successful
      end

      it 'sets error_message', :vcr do
        token = Stripe::Token.create(
          :card => {
            number: '4000000000000002',
            exp_month: 6,
            exp_year: 2016,
            cvc: 314
          }
        ).id

        customer = StripeWrapper::Customer.create(
          card: token,
          plan: '999_monthly',
          email: 'testemail@example.com',
          description: 'Test charge'
        )

        expect(customer.error_message).to eq('Your card was declined.')
      end
    end
  end
end
