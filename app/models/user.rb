class User < ApplicationRecord
  validates :name, :birthdate, :gender, :latitude, :longitude, presence: true
end
