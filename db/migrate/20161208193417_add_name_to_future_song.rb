class AddNameToFutureSong < ActiveRecord::Migration[5.0]
  def change
    add_column :future_songs, :name, :string
  end
end
