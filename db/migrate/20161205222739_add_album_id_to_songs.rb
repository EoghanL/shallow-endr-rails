class AddAlbumIdToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :album_id, :string
  end
end
