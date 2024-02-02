require 'active_model_serializers'

class ItemSerializer < ActiveModel::Serializer
  belongs_to :inventory
  attributes :id, :name
end
