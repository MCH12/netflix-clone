require 'spec_helper'

feature 'Admin adds video' do
  scenario 'admin successfully adds a new video' do
    admin = Fabricate(:admin)
    test_category = Fabricate(:category, title: 'Test Category')
    sign_in(admin)
    visit new_admin_video_path


    fill_in 'Title', with: 'Test Video'
    select test_category.title, from: 'Select Categories'
    fill_in 'Description', with: Faker::Lorem.paragraph(1)
    attach_file 'Large cover', 'spec/support/uploads/vim_large.png'
    attach_file 'Small cover', 'spec/support/uploads/vim_small.png'
    fill_in 'Video URL', with: (video_url = Faker::Internet.url)

    click_button 'Add Video'

    visit logout_path
    sign_in #uses regular use default
    expect(page).to have_selector("img[src='/uploads/vim_small.png']")

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/vim_large.png']")
    expect(page).to have_selector("a[href='#{video_url}']")
  end
end
