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

  describe '#clocked_records' do
    let!(:user) { create(:user) }
    let!(:first_clocked_record) { create(:clocked_record, user: user) }
    let!(:second_clocked_record) { create(:clocked_record, user: user, clocked_in: 5.minutes.since) }

    it do
      expect(user.clocked_records).to match_array([first_clocked_record, second_clocked_record])
      expect(user.clocked_records.first).to eq(second_clocked_record)
    end
  end

  describe '#following_clocked_records' do
    let!(:user) { create(:user) }
    let!(:clocked_record) { create(:clocked_record, user: user) }
    let!(:followed_user) { create(:user) }
    let!(:following) { create(:following, followed: followed_user, follower: user) }
    let!(:following_clocked_record) { create(:clocked_record, user: followed_user) }

    it do
      expect(user.following_clocked_records).to match_array([following_clocked_record])
    end
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

  describe '#clocked_in!' do
    let!(:user) { create(:user) }
    let!(:first_clocked_record) { create(:clocked_record, user: user) }
    let!(:clocked_in) { 5.minutes.since }

    subject { user.clocked_in!(clocked_in) }

    context 'when failed in validation' do
      let!(:clocked_in) { 5.minutes.ago }

      it 'raise ActiveRecord::RecordInvalid exception' do
        expect(user.clocked_records.first).to eq first_clocked_record
        expect{ subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    it 'clocked in successfully' do
      expect(user.clocked_records.first).to eq first_clocked_record
      expect{ subject }.to change{ ClockedRecord.count }.from(1).to(2)
      new_clocked_record = user.reload.clocked_records.first
      expect(new_clocked_record.clocked_in).to eq clocked_in
      expect(new_clocked_record.status).to eq 'wakeup'
      expect(new_clocked_record.slot_seconds).to eq 300
    end
  end

  describe '#following_sleep_rank_weekly' do
    let!(:user) { create(:user) }
    let!(:clocked_record) { create(:clocked_record, user: user) }
    let!(:followed_user) { create(:user) }
    let!(:following) { create(:following, followed: followed_user, follower: user) }

    before do
      create(:clocked_record, user: followed_user, clocked_in: 1.week.ago)
      @expected_record_1 = create(:clocked_record, user: followed_user, clocked_in: 1.week.ago + 1.hour)
      create(:clocked_record, user: followed_user, clocked_in: 1.week.ago + 2.hour)
      @expected_record_2 = create(:clocked_record, user: followed_user, clocked_in: 1.week.ago + 6.hour)
      create(:clocked_record, user: followed_user)
      create(:clocked_record, user: followed_user, clocked_in: 5.minutes.since)
    end

    it do
      expect(user.following_sleep_rank_weekly).to match_array([@expected_record_1, @expected_record_2])
      expect(user.following_sleep_rank_weekly.first).to eq(@expected_record_2)
    end
  end
end
