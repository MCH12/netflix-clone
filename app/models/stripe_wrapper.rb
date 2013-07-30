module StripeWrapper
  class Customer
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          card: options[:card],
          plan: '999_monthly',
          email: options[:email],
          description: options[:description]
        )
        new(response: response)
      rescue Stripe::InvalidRequestError
        new(error_message: 'Something went wrong.')
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end

    def id
      response.id
    end
  end
end
