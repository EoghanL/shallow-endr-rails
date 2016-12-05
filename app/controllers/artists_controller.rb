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
    byebug
    #if artist !exist then send back results[0..2](subsequent artist create) else render the stored artist from the DB(just do artist show)
    searchTerm = 'The Strokes'
    # this is where we would search and let them pick the correct result
    artistId = "f181961b-20f7-459e-89de-920ef03c7ed0"
    @artist = MusicBrainz::Artist.find(artistId)
    @albums = []
    @artist.release_groups.each_with_index { |rel_group,ind|
      if (rel_group.type == "Album")
        @songs = @artist.release_groups[ind].releases.first.tracks
        @albums.push({name: rel_group.title, id: rel_group.id, songs: @songs})
      end
    }
    #@albums is an array of hashes, with keys for title, id and songs (points to an array of MB Recordings)
    render json: @albums
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
    @artist = Artist.new(artist_params)

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
      params.require(:artist).permit(:name)
    end
end
