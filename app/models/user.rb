class User < ApplicationRecord
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :email, presence: true
  validates :email, uniqueness: true
  # validates :username, presence: true
  # validates :email, uniqueness: true
  # validates :password, presence: true
  validates_confirmation_of :password


  has_many :future_songs

  has_many :rankings

  has_secure_password

end
