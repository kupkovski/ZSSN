# frozen_string_literal: true

# the inter connection between Items and Inventories
class InventoryItem < ApplicationRecord
  belongs_to :item
  belongs_to :inventory
end
