# frozen_string_literal: true

# a user Inventory containing his/her items
class Inventory < ApplicationRecord
  belongs_to :user
  has_many :inventory_items
  has_many :items, through: :inventory_items
end
