class AddFutureSongsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :future_songs, :string
  end
end
