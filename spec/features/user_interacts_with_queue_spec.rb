require 'spec_helper'

feature 'user interacts with queue' do
  scenario 'user adds and reorders videos in queue' do
    category = Fabricate(:category)
    video1 = Fabricate(:video, title: 'video1_title', categories: [category])
    video2 = Fabricate(:video, title: 'video2_title', categories: [category])
    sign_in

    add_to_queue(video1)
    page.should have_content('- My Queue')
    add_to_queue(video2)

    click_link 'My Queue'
    expect(find_position_in_queue(video1).value).to eq('1')
    expect(find_position_in_queue(video2).value).to eq('2')

    find_position_in_queue(video1).set(2)
    find_position_in_queue(video2).set(1)
    click_button 'Update Instant Queue'
    
    expect(find_position_in_queue(video1).value).to eq('2')
    expect(find_position_in_queue(video2).value).to eq('1')
    end

  def add_to_queue(video)
    visit_video(video)
    click_link "+ My Queue"
  end

  def remove_from_queue(video)
    visit root_path
    find("a[href='/videos/#{video.id}']").click
    click_link "- My Queue"
  end

  def find_position_in_queue(video)
    find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']")
    #without xpath
    #add to position input field: data: { video_id: queue_item.video.id }
    #find with this: find("input[data-video-id='#{video1.id}']")
  end
end
