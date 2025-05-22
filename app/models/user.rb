class User < ApplicationRecord
  validates :name, :birthdate, :gender, :latitude, :longitude, presence: true

  has_many :infection_accusations, foreign_key: :reporter_id, class_name: 'InfectedUserReport'
  has_many :infection_suspections, foreign_key: :suspect_id, class_name: 'InfectedUserReport'

  def infected?
    reports = infection_suspections.group(:reporter_id).size
    return false if reports.empty?

    reports.keys.size >= 3
  end
end
