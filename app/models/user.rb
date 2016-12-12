class User < ApplicationRecord
  has_many :future_songs

  has_many :rankings

  has_secure_password

end
