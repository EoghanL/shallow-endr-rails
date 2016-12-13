class AddWeightToRankings < ActiveRecord::Migration[5.0]
  def change
    add_column :rankings, :weight, :integer
  end
end
