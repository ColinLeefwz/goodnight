require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'GET /users/:user_id/followers' do
    let!(:user) { create(:user) }
    let!(:follower_user) { create(:user) }
    let!(:following) { create(:following, followed: user, follower: follower_user) }
    let(:response_body) { JSON.parse(response.body) }
    let(:expected_body) do
      {
        'id' => follower_user.id,
        "name" => follower_user.name
      }
    end

    subject { get user_followers_path(user_id: user.id) }

    it 'returns all followers' do
      subject
      expect(response_body).to match_array([expected_body])
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/:user_id/followings' do
    let!(:user) { create(:user) }
    let!(:followed_user) { create(:user) }
    let!(:following) { create(:following, followed: followed_user, follower: user) }
    let(:response_body) { JSON.parse(response.body) }
    let(:expected_body) do
      {
        'id' => followed_user.id,
        "name" => followed_user.name
      }
    end

    subject { get user_followings_path(user_id: user.id) }

    it 'returns all followings' do
      subject
      expect(response_body).to match_array([expected_body])
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/:user_id/is_following' do
    let!(:user) { create(:user) }
    let!(:followed_user) { create(:user) }
    let!(:unfollowed_user) { create(:user) }
    let!(:following) { create(:following, followed: followed_user, follower: user) }
    let(:follow_id) { followed_user.id }
    let(:response_body) { JSON.parse(response.body) }

    subject { get user_is_following_path(user_id: user.id), params: { id: follow_id} }

    context 'when there is unfollowed user' do
      let(:follow_id) { unfollowed_user.id }

      it 'returns true' do
        subject
        expect(response_body['result']).to eq(false)
        expect(response).to have_http_status(:ok)
      end
    end

    it 'returns true' do
      subject
      expect(response_body['result']).to eq(true)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /users/:user_id/follow' do
    let!(:user) { create(:user) }
    let!(:followed_user) { create(:user) }
    let(:follow_id) { followed_user.id }
    let(:response_body) { JSON.parse(response.body) }
    let(:expected_body) do
      {
        'id' => followed_user.id,
        'name' => followed_user.name
      }
    end

    subject { put user_follow_path(user_id: user.id), params: { id: follow_id } }

    context 'when there is an exception' do
      let(:follow_id) { 'not_available' }
      let(:expected_body) do
        {
          'status' => 400,
          'message' => 'Bad Request'
        }
      end

      it 'returns 400' do
        expect{ subject }.not_to change{ Following.count }
        expect(response_body).to eq(expected_body)
        expect(response).to have_http_status(400)
      end
    end

    it 'returns all followings' do
      expect{ subject }.to change{ Following.count }.from(0).to(1)
      expect(response_body).to match_array([expected_body])
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /users/:user_id/unfollow' do
    let!(:user) { create(:user) }
    let!(:followed_user) { create(:user) }
    let!(:following) { create(:following, followed: followed_user, follower: user) }
    let(:follow_id) { followed_user.id }
    let(:response_body) { JSON.parse(response.body) }

    subject { put user_unfollow_path(user_id: user.id), params: { id: follow_id } }

    context 'when there is an exception' do
      let(:follow_id) { 'not_available' }
      let(:expected_body) do
        {
          'status' => 400,
          'message' => 'Bad Request'
        }
      end

      it 'returns 400' do
        expect{ subject }.not_to change{ Following.count }
        expect(response_body).to eq(expected_body)
        expect(response).to have_http_status(400)
      end
    end

    it 'returns all followings' do
      expect{ subject }.to change{ Following.count }.from(1).to(0)
      expect(response_body).to match_array([])
      expect(response).to have_http_status(:ok)
    end
  end
end
