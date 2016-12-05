class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :update, :destroy]
  MusicBrainz.configure do |c|
    # Application identity (required)
    c.app_name = "ShallowEndr"
    c.app_version = "1.0"
    c.contact = "marc@beldgroup.com"

    # Cache config (optional)
    c.cache_path = "/tmp/musicbrainz-cache"
    c.perform_caching = true

    # Querying config (optional)
    c.query_interval = 1.2 # seconds
    c.tries_limit = 2
  end


  def search
    #if artist !exist then send back results[0..2](subsequent artist create) else render the stored artist from the DB(just do artist show)
    searchTerm = artist_params[:searchTerm]
    if(Artist.find_by(name: artist_params[:searchTerm]))
      @artist = Artist.find_by(name: artist_params[:searchTerm])
      render json: @artist
    else
      @artistResults = MusicBrainz::Artist.search(searchTerm)
      @artistResults = @artistResults.slice(0,3)
      render json: @artistResults
    end


  end
  # GET /artists
  def index
    @artists = Artist.all

    render json: @artists
  end

  # GET /artists/1
  def show
    render json: @artist
  end

  # POST /artists
  def create
    byebug
    @artist = Artist.find_or_create_by(id: artist_params[:id], name: artist_params[:name])
    byebug

    if @artist.save
      render json: @artist, status: :created, location: @artist
    else
      render json: @artist.errors, status: :unprocessable_entity
    end
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
      params.require(:artist).permit(:name, :searchTerm, :mb_id, :display_name)
    end
end
