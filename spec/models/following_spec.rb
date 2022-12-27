require 'rails_helper'

RSpec.describe Following, type: :model do
  describe '#follower' do
    let!(:follower_user) { create(:user) }
    let!(:following) { create(:following, follower: follower_user) }

    it do
      expect(following.follower).to eq(follower_user)
    end
  end

  describe '#followed' do
    let!(:followed_user) { create(:user) }
    let!(:following) { create(:following, followed: followed_user) }

    it do
      expect(following.followed).to eq(followed_user)
    end
  end

  describe '#valid?' do
    let!(:following) { create(:following) }

    context 'when follower_id is blank' do
      it 'return false' do
        following.follower_id = nil
        expect(following.valid?).to be false
      end
    end

    context 'when followed_id is blank' do
      it 'return false' do
        following.followed_id = nil
        expect(following.valid?).to be false
      end
    end

    it 'is valid' do
      expect(following.valid?).to be true
    end
  end
end
