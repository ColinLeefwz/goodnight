class UsersController < ApplicationController
  before_action :set_user

  # GET /users/:user_id/followers
  def followers
    followers = @user.followers
    render json: followers, each_serializer: UserSerializer
  end

  # GET /users/:user_id/is_following
  def is_following
    result = @user.following?(follow_params[:id])
    render json: { result: result }
  end

  # GET /users/:user_id/followings
  def followings
    followings = @user.followings
    render json: followings, each_serializer: UserSerializer
  end

  # PUT /users/:user_id/follow
  def follow
    @user.follow!(follow_params[:id])
    render json: @user.followings, each_serializer: UserSerializer
  rescue StandardError
    render status: 400, json: { status: 400, message: 'Bad Request' }
  end

  # PUT /users/:user_id/unfollow
  def unfollow
    @user.unfollow!(follow_params[:id])
    render json: @user.followings, each_serializer: UserSerializer
  rescue StandardError
    render status: 400, json: { status: 400, message: 'Bad Request' }
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def follow_params
    params.permit(:id)
  end
end
