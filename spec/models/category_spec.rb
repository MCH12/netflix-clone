require 'spec_helper'

describe Category do
  it { should have_and_belong_to_many(:videos) }
  it { should validate_presence_of(:title) }

  describe "self.recent_videos" do
    let(:category) { Fabricate(:category) }
    let!(:video2) { Fabricate(:video, categories: [category]) }
    let!(:video1) { Fabricate(:video, categories: [category]) }

    it "returns videos in descending order by created_at" do
      expect(category.recent_videos).to eq([video1, video2])
    end

    it "returns all videos if vidoes < 6" do
      expect(category.recent_videos.size).to eq(2)
    end

    it "returns 6 videos if videos > 6" do
      7.times { Fabricate(:video, categories: [category]) }
      expect(category.recent_videos.size).to eq(6)
    end
  end
end
