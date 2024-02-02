class Item < ApplicationRecord
  validates :name, :cost, presence: true
  validates :cost, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  has_many :inventory_items
  has_many :inventories, through: :inventory_items
end
