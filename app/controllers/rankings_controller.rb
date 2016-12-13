class RankingsController < ApplicationController
  before_action :set_ranking, only: [:show, :update, :destroy]

  # GET /rankings
  def index
    @rankings = Ranking.all

    render json: @rankings
  end

  # GET /rankings/1
  def show
    render json: @ranking
  end

  # POST /rankings
  def create
    #new rankings need a song_id, user_id, and artist_id
    #should validate the uniqueness of a user and artist in combo
    #(can probably skip song_id validations as every song_id is already unique?)
    #so that users can only rank one song per artist
    #1.) every song list element is now going to need an artist and song id to send back to ranking control
    #2.) send back localStorage.jwt for the users controller to decode
    #3.) possibly keep a running store of all artist and song combos in state?
    @song = Song.find(ranking_params[:song_id])
    @newWeight = @song.current_weight + ranking_params[:weight].to_i
    @song.update(current_weight: @newWeight)
    @ranking = Ranking.new(ranking_params)
    @artistSongs = Artist.find(@ranking[:artist_id]).songs.order('current_weight DESC, name')
    if @ranking.save
      render json: { rankings: @ranking, songs: @artistSongs }, status: :created, location: @ranking
    else
      render json: @ranking.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rankings/1
  def update
    if @ranking.update(ranking_params)
      render json: @ranking
    else
      render json: @ranking.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rankings/1
  def destroy
    @ranking_id = @ranking.id
    @song = Song.find(@ranking[:song_id])
    @newWeight = @song.current_weight - @ranking[:weight].to_i
    @song.update(current_weight: @newWeight)
    @artistSongs = Artist.find(@ranking[:artist_id]).songs.order('current_weight DESC, name')
    @ranking.destroy
    render json: { songs: @artistSongs, rankings: nil }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ranking
      @ranking = Ranking.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ranking_params
      params.require(:ranking).permit(:user_id, :song_id, :artist_id, :weight)
    end
end
