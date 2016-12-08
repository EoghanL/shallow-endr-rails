class FutureSongsController < ApplicationController
  before_action :set_future_song, only: [:show, :update, :destroy]

  # GET /future_songs
  def index
    @all_songs = FutureSong.all
    # @all_songs = FutureSong.all.map do |song|
    #   Song.find(song.song_id) #if(future_song_params[:user_id] == song.user_id)
    # end
    render json: @all_songs
  end

  # GET /future_songs/1
  def show
    render json: @future_song
  end

  # POST /future_songs
  def create
    @future_song = FutureSong.new(future_song_params)

    if @future_song.save
      render json: @future_song, status: :created, location: @future_song
    else
      render json: @future_song.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /future_songs/1
  def update
    if @future_song.update(future_song_params)
      render json: @future_song
    else
      render json: @future_song.errors, status: :unprocessable_entity
    end
  end

  # DELETE /future_songs/1
  def destroy
    byebug
    @future_song.destroy
    render json: { message: "Song Successfully Removed"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_future_song
      @future_song = FutureSong.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def future_song_params
      params.require(:future_song).permit(:user, :song, :user_id, :song_id, :name)
    end
end
