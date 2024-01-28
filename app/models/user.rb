class User < ApplicationRecord
  validates :name, :gender, :latitude, :longitude, :birthdate, presence: true

  validates_numericality_of :latitude
  validates_numericality_of :longitude
end
