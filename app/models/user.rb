class User < ApplicationRecord
  has_many :active_followings, class_name: 'Following', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_followings, class_name: 'Following', foreign_key: 'followed_id', dependent: :destroy
  has_many :followings, through: :active_followings, source: :followed
  has_many :followers, through: :passive_followings, source: :follower

  # Judge if object user id is followed by current user
  #
  # @param id [Integer] object user id
  #
  # @return [Boolean] judgement result of following
  def following?(id)
    active_followings.exists?(followed_id: id)
  end

  # Follow the object user id
  #
  # @param id [Integer] object user id
  #
  # @rase [ActiveRecord::RecordInvalid] when failed validation
  # @return [true] succeed in following object user
  def follow!(id)
    active_followings.create!(followed_id: id)
  end

  # Unfollow the object user id
  #
  # @param id [Integer] object user id
  #
  # @rase [ActiveRecord::RecordInvalid] when failed validation
  # @return [true] succeed in unfollowing object user
  def unfollow!(id)
    active_following = active_followings.find_by(followed_id: id)
    active_following.destroy!
  end
end
