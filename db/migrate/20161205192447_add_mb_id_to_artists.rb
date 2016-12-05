class AddMbIdToArtists < ActiveRecord::Migration[5.0]
  def change
    add_column :artists, :mb_id, :string
  end
end
