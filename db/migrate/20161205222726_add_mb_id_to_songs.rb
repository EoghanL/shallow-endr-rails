class AddMbIdToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :mb_id, :string
  end
end
