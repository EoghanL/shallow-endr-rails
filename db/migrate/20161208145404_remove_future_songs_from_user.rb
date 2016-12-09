class RemoveFutureSongsFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :future_songs, :string
  end
end
