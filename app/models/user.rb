class User < ApplicationRecord
  validates :first_name, presence: true
  has_many :future_songs

  has_many :rankings

  has_secure_password

end
