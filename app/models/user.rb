class User < ApplicationRecord
  has_many :clocked_records, dependent: :destroy
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
  # @raise [ActiveRecord::RecordInvalid] when failed validation
  # @return [true] succeed in following object user
  def follow!(id)
    active_followings.create!(followed_id: id)
  end

  # Unfollow the object user id
  #
  # @param id [Integer] object user id
  #
  # @raise [ActiveRecord::RecordInvalid] when failed validation
  # @return [true] succeed in unfollowing object user
  def unfollow!(id)
    active_following = active_followings.find_by(followed_id: id)
    active_following.destroy!
  end

  # User clocked in time
  #
  # @param clocked_in [Datetime] clocked in timestamp
  #
  # @raise [ActiveRecord::RecordInvalid] when failed validation
  # @return [true] succeed in clocking in the timestamp
  def clocked_in!(clocked_in)
    clocked_records.create!(clocked_in: clocked_in)
  end
end
