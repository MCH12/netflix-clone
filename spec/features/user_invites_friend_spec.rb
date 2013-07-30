require 'spec_helper'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted', :vcr, :js do
    user = Fabricate(:user)
    sign_in(user)

    invite_friend
    visit logout_path
    friend_accepts_invitation
    friend_signs_in
    friend_should_follow(user)
    visit logout_path
    sign_in(user)
    inivter_should_follow_friend
  end

  def invite_friend
    visit invite_path
    fill_in "Friend's Name", with: 'Friend Name'
    fill_in "Friend's Email", with: 'friend@example.com'
    click_button 'Send Invitation'
  end

  def friend_accepts_invitation
    open_email 'friend@example.com'
    current_email.click_link 'Accept Invitation'
    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'Friend Name'
    fill_in 'Credit Card Number', with: '4242424242424242'
    fill_in 'Security Code', with: '123'
    select '7 - July', from: 'date_month'
    select '2016', from: 'date_year'
    click_button 'Sign Up'
  end

  def friend_signs_in
    fill_in 'Email Address', with: 'friend@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign In'
  end

  def friend_should_follow(inviter)
    click_link 'People'
    expect(page).to have_content inviter.full_name
  end

  def inivter_should_follow_friend
    click_link 'People'
    expect(page).to have_content 'Friend Name'
  end
end
