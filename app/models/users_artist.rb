class UsersArtist < ApplicationRecord
  belongs_to :user, :artist
  has_many :songs
end
