module Adapter
  class MBAdapter



    def initialize
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
    end

    def getArtists(search_term)
      MusicBrainz::Artist.search(search_term).slice(0,5)
    end

    def getSpecificArtist(mb_id)
      MusicBrainz::Artist.find(mb_id)
    end

    def getSongs(artist_id)
      return
    end

  end
end
