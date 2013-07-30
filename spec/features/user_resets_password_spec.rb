require 'spec_helper'

feature 'User resets password' do
  scenario 'User successfully resets password' do
    user = Fabricate(:user)
    visit login_path
    click_link 'Forgot Password?'
    fill_in "Email Address", with: user.email
    click_button 'Send Email'

    open_email(user.email)
    current_email.click_link('Reset Password')

    fill_in "New Password", with: 'password'
    click_button 'Reset Password'

    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Sign In'

    expect(page).to have_content("Welcome, #{user.full_name}")

    clear_email
  end
end
