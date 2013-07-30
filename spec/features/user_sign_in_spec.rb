require 'spec_helper'

feature 'user signs in' do
  scenario 'with valid email and password' do
    user = Fabricate(:user)
    sign_in(user)
    page.should have_content user.full_name
  end
end
