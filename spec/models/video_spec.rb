require 'spec_helper'

describe Video do
  it { should have_and_belong_to_many(:categories) }
  it { should have_many(:queue_items) }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search_by_title" do
    let(:video1) { Fabricate(:video, title: 'test video') }
    let(:video2) { Fabricate(:video, title: 'ruby test video') }

    it "returns an empty array if no match" do
      expect(Video.search_by_title('search')).to eq([])
    end

    it "returns an array of one video for an exact match" do
      expect(Video.search_by_title('ruby test video')).to eq([video2])
    end

    it "returns an array of one video for a partial match" do
      expect(Video.search_by_title('ruby')).to eq([video2])
    end

    it "returns an array of all matches ordered by created_at" do
      expect(Video.search_by_title('video')).to eq([video1, video2])
    end

    it "returns an empty array for a search with an empty string" do
      expect(Video.search_by_title('')).to eq([])
    end
  end
end
