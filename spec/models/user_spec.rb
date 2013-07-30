require 'spec_helper'

describe User do
  it { should have_many(:reviews) }
  it { should have_many(:queue_items).order(:position) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }

  it_behaves_like 'tokenable' do
    let(:object) { Fabricate(:user) }
  end

  describe ".video_queued?" do
    let!(:video) { Fabricate(:video) }
    let!(:user) { Fabricate(:user) }
    it 'returns true when the user has video in queue' do
      Fabricate(:queue_item, user: user, video: video)

      expect(user.video_queued?(video)).to be_true
    end

    it 'returns false when the user does not have video in queue' do
      expect(user.video_queued?(video)).to be_false
    end
  end 

  describe '.queue_id' do
    it "gets id of video in user's queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, id: 2, user: user, video: video)

      expect(user.queue_id(video)).to eq(queue_item.id)
    end

    it "returns nil if no video to find" do
      user = Fabricate(:user)
      video = Fabricate(:video)

      expect(user.queue_id(video)).to be_nil
    end
  end

  describe '.following?' do
    let(:leader) { Fabricate(:user) }
    let(:follower) { Fabricate(:user) }
    before { Relationship.create!(leader: leader, follower: follower) }

    it 'returns true if user is following another user' do
      expect(follower.following?(leader)).to be_true
    end

    it 'returns false if user is not following checked user' do
      expect(leader.following?(follower)).to be_false
    end
  end

  describe '.follow' do
    it 'follows another user' do
      leader = Fabricate(:user)
      follower = Fabricate(:user)
      follower.follow(leader)
      expect(follower.following?(leader)).to be_true
    end
  end

  describe '.can_follow?' do
    it 'cannot follow self' do
      leader = Fabricate(:user)
      follower = leader
      expect(follower.can_follow?(leader)).to be_false
    end

    it 'cannot follow if already following' do
      leader = Fabricate(:user)
      follower = Fabricate(:user)
      Relationship.create(leader: leader, follower: follower)
      expect(follower.can_follow?(leader)).to be_false
    end
  end

  describe '.relationship_id' do
    let(:leader) { Fabricate(:user) }
    let(:follower) { Fabricate(:user) }
    before { Relationship.create!(leader: leader, follower: follower) }

    it 'gets id of of relationship between user and leader' do
      expect(follower.relationship_id(leader)).to eq(1)
    end

    it 'returns nil if user has no relationship with leader' do
      expect(leader.relationship_id(follower)).to be_nil
    end
  end
end
