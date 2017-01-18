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
    @song = Song.find(ranking_params[:song_id])
    @new_weight = @song.current_weight + ranking_params[:weight].to_i
    @ranking = Ranking.new(ranking_params)
    @artist_songs = Artist.find(@ranking[:artist_id]).songs.order('current_weight DESC, name')
    if @ranking.save
      @song.update(current_weight: @new_weight)
      render json: { rankings: @ranking, songs: @artist_songs }, status: :created, location: @ranking
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
    @new_weight = @song.current_weight - @ranking[:weight].to_i
    @song.update(current_weight: @new_weight)
    @artist_songs = Artist.find(@ranking[:artist_id]).songs.order('current_weight DESC, name')
    @ranking.destroy
    render json: { songs: @artist_songs, rankings: nil }
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
