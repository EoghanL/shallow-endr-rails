class RemoveRatingFromSongs < ActiveRecord::Migration[5.0]
  def change
    remove_column :songs, :rating, :integer
  end
end
