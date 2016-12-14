class Song < ApplicationRecord
  belongs_to :artist
  has_many :rankings
  validates_uniqueness_of :mb_id
end
