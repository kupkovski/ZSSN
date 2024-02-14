# frozen_string_literal: true

# an entry of some user reporting other user as infected
class InfectedUserReport < ApplicationRecord
  belongs_to :suspect, class_name: 'User'
  belongs_to :reporter, class_name: 'User'

  validates :suspect, :reporter, presence: true
end
