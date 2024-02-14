# frozen_string_literal: true

require 'active_model_serializers'

# Represents an Item in JSON
class ItemSerializer < ActiveModel::Serializer
  belongs_to :inventory
  attributes :id, :name
end
