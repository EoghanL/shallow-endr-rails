class AddSongIdToFutureSong < ActiveRecord::Migration[5.0]
  def change
    add_column :future_songs, :song_id, :integer
  end
end
