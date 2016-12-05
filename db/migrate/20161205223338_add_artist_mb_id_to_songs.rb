class AddArtistMbIdToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :artist_mb_id, :string
  end
end
