class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :update, :destroy]

  def search
    mb_adapt = Adapter::MBAdapter.new
    #Searches for an artist in DB
    search_term = artist_params[:search_term].downcase.gsub(' ', '')
    @artist = Artist.find_by(name: search_term)
    if(@artist)
      show
    else
      @artist_results = mb_adapt.get_artists(artist_params[:search_term])
      @partial_matches = Artist.all.select{ |artist| artist.name.include?(search_term)}
      if (@partial_matches)
        @partial_match_names = @partial_matches.map {|match| match[:display_name]}
        @artist_results = @artist_results.select {|artist| !@partial_match_names.include?(artist[:name])}
      end
      @artist_results.map! do |artist|
        mb_adapt.get_specific_artist(artist[:mbid]) if mb_adapt.get_specific_artist(artist[:mbid]).date_begin < DateTime.now
      end
      @artist_results.select! { |artist| artist != nil }
      render json: {new_artists: @artist_results, existing_artists: @partial_matches}
    end
  end

  # GET /artists
  def index
    @artists = Artist.all

    render json: @artists
  end

  # GET /artists/1
  def show
    @user = current_user
    @rankings = @user.rankings.find_by(artist_id: @artist.id)
    render json: { artist: @artist, songs: @artist.songs.order('current_weight DESC, name'), rankings: @rankings }
  end

  # POST /artists
  def create
    mb_adapt = Adapter::MBAdapter.new
    @artist = Artist.create(artist_params)
    @artist_results = mb_adapt.get_specific_artist(artist_params[:mb_id])
    @artist_and_albums = mb_adapt.get_and_add_songs(@artist_results, @artist)
    render json: @artist_and_albums
  end

  # PATCH/PUT /artists/1
  def update
    if @artist.update(artist_params)
      render json: @artist
    else
      render json: @artist.errors, status: :unprocessable_entity
    end
  end

  # DELETE /artists/1
  def destroy
    @artist.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artist
      @artist = Artist.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def artist_params
      params.require(:artist).permit(:name, :search_term, :mb_id, :display_name, :id)
    end
end
