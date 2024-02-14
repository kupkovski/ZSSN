# frozen_string_literal: true

require 'active_model_serializers'

# Represents an Inventory in JSON
class InventorySerializer < ActiveModel::Serializer
  attributes :id, :items

  belongs_to :user
  has_many :items
  attributes :id
end
