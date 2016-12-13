class AddCurrentWeightToSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :songs, :current_weight, :integer, :default => 0
  end
end
