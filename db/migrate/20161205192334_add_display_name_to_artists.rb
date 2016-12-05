class AddDisplayNameToArtists < ActiveRecord::Migration[5.0]
  def change
    add_column :artists, :display_name, :string
  end
end
