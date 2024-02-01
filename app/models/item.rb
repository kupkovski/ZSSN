class Item < ApplicationRecord
  validates :name, :cost, presence: true
  validates :cost, numericality: { only_integer: true, greater_than_or_equal_to: 0}
end
