class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  #@wrapper = Discogs::Wrapper.new("ShallowEndr")

  #for musicbrainz to get albums: https://musicbrainz.org/ws/2/artist/f181961b-20f7-459e-89de-920ef03c7ed0?inc=release-groups
  #find type="Album"
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


  def authenticate
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
    byebug
  end

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
      render json: @user, status: :created, location: @user
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

  def login
    byebug
    @user = User.find_by(email: user_params[:email])
    if @user
      if @user.authenticate(user_params[:password])
        jwt_token = Auth.issue({user_id: @user.id})
        render json: {jwt: jwt_token}
      else
        render json: { errors: "Incorrect Password"}
      end
    else
      render json: { errors: "Unrecognized user" }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :email, :password)
    end
end
