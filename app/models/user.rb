class User < ApplicationRecord
  has_many :future_songs
  has_many :songs, through: :future_songs
  has_secure_password

end
