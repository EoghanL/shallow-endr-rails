class CreateFutureSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :future_songs do |t|
      t.integer :user_id
      t.string :song_mb_id

      t.timestamps
    end
  end
end
