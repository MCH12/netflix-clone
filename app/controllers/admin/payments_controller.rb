class Admin::PaymentsController < ApplicationController
  def index
    @payments = Payment.last(8)
  end
end
