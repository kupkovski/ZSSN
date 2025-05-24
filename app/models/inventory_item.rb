# frozen_string_literal: true

class InventoryItem < ApplicationRecord
  belongs_to :item
  belongs_to :inventory
end
