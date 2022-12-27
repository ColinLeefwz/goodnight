class User < ApplicationRecord
  has_many :active_followings, class_name: 'Following', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_followings, class_name: 'Following', foreign_key: 'followed_id', dependent: :destroy
  has_many :followings, through: :active_followings, source: :followed
  has_many :followers, through: :passive_followings, source: :follower
end
