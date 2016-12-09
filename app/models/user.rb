class User < ApplicationRecord
  has_many :future_songs
  has_many :songs, through: :future_songs
  has_many :users_artists
  has_many :artists, through: :users_artists
  has_secure_password

end
