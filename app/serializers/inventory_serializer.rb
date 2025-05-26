require "active_model_serializers"

class InventorySerializer < ActiveModel::Serializer
  has_many :items
end
