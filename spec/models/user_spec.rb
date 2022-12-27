require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#followings' do
    let!(:user) { create(:user) }
    let!(:followed_user) { create(:user) }
    let!(:following) { create(:following, followed: followed_user, follower: user) }

    it { expect(user.followings).to match_array([followed_user]) }
  end

  describe '#followers' do
    let!(:user) { create(:user) }
    let!(:follower_user) { create(:user) }
    let!(:following) { create(:following, followed: user, follower: follower_user) }

    it { expect(user.followers).to match_array([follower_user]) }
  end

  describe '#following?' do
    let!(:user) { create(:user) }
    let!(:followed_user) { create(:user) }
    let!(:unfollowed_user) { create(:user) }
    let!(:following) { create(:following, followed: followed_user, follower: user) }

    it do
      expect(user.following?(followed_user.id)).to be true
      expect(user.following?(unfollowed_user.id)).to be false
    end
  end

  describe '#follow!' do
    let!(:user) { create(:user) }
    let!(:expected_followed_user) { create(:user) }

    subject { user.follow!(expected_followed_user.id) }

    it 'follows user successfully' do
      expect(user.reload.following?(expected_followed_user.id)).to be false
      expect{ subject }.to change{ Following.count }.from(0).to(1)
      expect(user.reload.following?(expected_followed_user.id)).to be true
    end
  end

  describe '#unfollow!' do
    let!(:user) { create(:user) }
    let!(:expected_unfollowed_user) { create(:user) }
    let!(:following) { create(:following, followed: expected_unfollowed_user, follower: user) }

    subject { user.unfollow!(expected_unfollowed_user.id) }

    it 'unfollows user successfully' do
      expect(user.reload.following?(expected_unfollowed_user.id)).to be true
      expect{ subject }.to change{ Following.count }.from(1).to(0)
      expect(user.reload.following?(expected_unfollowed_user.id)).to be false
    end
  end
end
