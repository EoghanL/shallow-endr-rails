class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  skip_before_action :authenticate, only: [:create, :getUserId]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      jwt_token = Auth.issue({user_id: @user.id})
      render json: { user: @user, jwt: jwt_token }
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def getUserId
    byebug
    @user_id = Auth.decode(params[:user][:jwt])
    render json: @user_id
  end


  def add_song
    song = Song.find_by(mb_id: user_params[:song_id])
    user = User.find(user_params[:user_id])
    FutureSong.create(user: user, song: song, name: song.name)
    render json: { message: "Song Successfully Added to List"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :password_confirmation, :email, :password, :song_id, :user_id, :jwt)
    end
end
