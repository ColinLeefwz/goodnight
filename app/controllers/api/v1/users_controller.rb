class Api::V1::UsersController < ApplicationController
  before_action :set_user

  # GET /api/v1/users/:user_id/followers
  def followers
    followers = @user.followers
    render json: followers, each_serializer: UserSerializer
  end

  # GET /api/v1/users/:user_id/is_following
  def is_following
    result = @user.following?(follow_params[:id])
    render json: { result: result }
  end

  # GET /api/v1/users/:user_id/followings
  def followings
    followings = @user.followings
    render json: followings, each_serializer: UserSerializer
  end

  # PUT /api/v1/users/:user_id/follow
  def follow
    @user.follow!(follow_params[:id])
    render json: @user.followings, each_serializer: UserSerializer
  rescue StandardError
    render status: 400, json: { status: 400, message: 'Bad Request' }
  end

  # PUT /api/v1/users/:user_id/unfollow
  def unfollow
    @user.unfollow!(follow_params[:id])
    render json: @user.followings, each_serializer: UserSerializer
  rescue StandardError
    render status: 400, json: { status: 400, message: 'Bad Request' }
  end

  # POST /api/v1/users/:user_id/clocked_in
  def clocked_in
    @user.clocked_in!(Time.current)
    render json: @user.clocked_records, each_serializer: ClockedRecordSerializer
  rescue StandardError
    render status: 400, json: { status: 400, message: 'Bad Request' }
  end

  # GET /api/v1/users/:user_id/sleep_rank
  def sleep_rank
    render json: @user.following_sleep_rank_weekly, each_serializer: ClockedRecordSerializer
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def follow_params
    params.permit(:id)
  end
end
