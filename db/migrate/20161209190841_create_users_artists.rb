class CreateUsersArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :users_artists do |t|
      t.integer :user_id
      t.integer :artist_id
      t.integer :song_one_id
      t.integer :song_two_id
      t.integer :song_three_id

      t.timestamps
    end
  end
end
