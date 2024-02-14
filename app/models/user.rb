# frozen_string_literal: true

# a User
class User < ApplicationRecord
  has_many :infection_accusations, foreign_key: :reporter_id, class_name: 'InfectedUserReport'
  has_many :infection_suspections, foreign_key: :suspect_id, class_name: 'InfectedUserReport'
  has_one :inventory

  validates :name, :gender, :latitude, :longitude, :birthdate, presence: true

  validates_numericality_of :latitude
  validates_numericality_of :longitude

  def infected?
    reports = infection_suspections.group(:reporter_id).size
    return false if reports.empty?

    reports.keys.size >= 3
  end
end
