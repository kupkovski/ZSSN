# frozen_string_literal: true

class Item < ApplicationRecord
  VALID_NAMES = %w[água comida remédio munição].freeze

  validates :name, :cost, presence: true
  validates :name, inclusion: { in: VALID_NAMES }
  validates :cost, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  has_many :inventory_items
  has_many :inventories, through: :inventory_items
end
