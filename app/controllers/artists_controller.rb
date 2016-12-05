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
    #Searches for an artist in DB
    searchTerm = artist_params[:searchTerm].downcase.gsub(' ', '')
    @artist = Artist.find_by(name: searchTerm)
    if(@artist)
      render json: @artist
    else
      @artistResults = MusicBrainz::Artist.search(artist_params[:searchTerm])
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
    @artist = Artist.create(artist_params)
    @artistResults = MusicBrainz::Artist.find(artist_params[:mb_id])
    @albums = []
    @artistResults.release_groups.each_with_index { |rel_group,ind|
      if (rel_group.type == "Album")
        @songs = @artistResults.release_groups[ind].releases.first.tracks
        @albums.push({name: rel_group.title, id: rel_group.id, songs: @songs})
      end
    }
    #@albums is an array of hashes, with keys for title, id and songs (points to an array of MB Recordings)
    #for each album, go through each song and create a new song with title and artist_id, return an array of song objects
    @albums.each { |album|
      album[:songs].each { |song|
        @song_info = {
          name: song.title,
          rating: 0,
          mb_id: song.recording_id,
          album_id: album[:id],
          artist_id: @artist.id,
          artist_mb_id: @artist.mb_id
        }
        Song.create(@song_info)
      }
    }
    @artistAndAlbums = {artist: @artist, albums: @albums}
    render json: @artistAndAlbums
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
