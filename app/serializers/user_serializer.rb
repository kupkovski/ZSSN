require 'active_model_serializers'

class UserSerializer < ActiveModel::Serializer
  has_one :inventory
  attributes :id, :name, :age, :infected

  def age
    ((Date.today - object.birthdate) / 365).floor
  end

  def infected
    object.infected?
  end
end
