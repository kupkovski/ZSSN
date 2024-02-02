require 'active_model_serializers'

class InventorySerializer < ActiveModel::Serializer
  attributes :id, :items

  belongs_to :user
  has_many :items
  attributes :id


end
