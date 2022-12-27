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
end
