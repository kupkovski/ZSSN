require "active_model_serializers"

class ItemSerializer < ActiveModel::Serializer
  attributes :name, :cost
end
