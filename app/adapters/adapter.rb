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
        c.query_interval = 1.5 # seconds
        c.tries_limit = 3
      end
    end

    def get_artists(search_term)
      MusicBrainz::Artist.search(search_term).slice(0,5)
    end

    def get_specific_artist(mb_id)
      MusicBrainz::Artist.find(mb_id)
    end

    def get_and_add_songs(artist_results, artist)
      @albums = []
      artist_results.release_groups.each_with_index { |rel_group,ind|
        if (rel_group.type == "Album")
          @songs = artist_results.release_groups[ind].releases.first.tracks
          @albums.push({name: rel_group.title, id: rel_group.id, songs: @songs})
        end
      }

      @song_list = []
      @albums.each { |album|
        album[:songs].each { |song|
          @song_info = {
            name: song.title,
            mb_id: song.recording_id,
            album_id: album[:id],
            artist_id: artist.id,
            artist_mb_id: artist.mb_id,
            current_weight: 0
          }
        @song_list << Song.create(@song_info)
        }
      }
      #send artist_id back to react for rendering
      {artist: artist, songs: @song_list}
    end

  end
end
