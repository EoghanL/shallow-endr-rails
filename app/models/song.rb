class Song < ApplicationRecord
  belongs_to :artist
  has_many :future_songs
  has_many :users, through: :future_songs

end
