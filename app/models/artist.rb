class Artist < ApplicationRecord
  has_many :songs
  has_many :users_artists
  has_many :artists, through: :users_artists

  validates_uniqueness_of :mb_id
end
