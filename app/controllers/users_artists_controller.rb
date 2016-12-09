class UsersArtistsController < ApplicationController
  before_action :set_users_artist, only: [:show, :update, :destroy]

  # GET /users_artists
  def index
    @users_artists = UsersArtist.all

    render json: @users_artists
  end

  # GET /users_artists/1
  def show
    render json: @users_artist
  end

  # POST /users_artists
  def create
    @users_artist = UsersArtist.new(users_artist_params)

    if @users_artist.save
      render json: @users_artist, status: :created, location: @users_artist
    else
      render json: @users_artist.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users_artists/1
  def update
    if @users_artist.update(users_artist_params)
      render json: @users_artist
    else
      render json: @users_artist.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users_artists/1
  def destroy
    @users_artist.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users_artist
      @users_artist = UsersArtist.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def users_artist_params
      params.require(:users_artist).permit(:user_id, :artist_id, :song_one_id, :song_two_id, :song_three_id)
    end
end
