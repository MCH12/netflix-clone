require 'spec_helper'

feature 'user follows' do
  scenario 'user follows and unfollows someone' do
    category = Fabricate(:category)
    video = Fabricate(:video, categories: [category])
    follower = Fabricate(:user)
    leader = Fabricate(:user)
    Fabricate(:review, user: leader, video: video)
    sign_in(follower)

    visit_video(video)
    click_link leader.full_name

    #These should stay on user#show page
    click_link 'Follow'
    click_link 'Unfollow'
    click_link 'Follow'

    click_link 'People' #switch to relationships#index page
    find("a[data-method='delete']").click #click to unfollow user
    find("a[data-dismiss='alert']").click #clear the flash[:notice]

    expect(page).to_not have_content(leader.full_name)
  end
end
