# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :user
  has_many :inventory_items
  has_many :items, through: :inventory_items
end
